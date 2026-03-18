#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'TXT'
Usage:
  update-live.sh \
    --agent <minisama|coach|lebron|curry> \
    --state <idle|working|sleeping|eating> \
    [--task <description|null>] \
    [--from <sender>] [--to <receiver>] [--msg <message>]

Notes:
- Requires: gh, jq
- Reads gist config from: data/gist-config.json (override with GIST_CONFIG)
TXT
}

AGENT=""
STATE=""
TASK=""
FROM=""
TO=""
MSG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) AGENT="${2:-}"; shift 2;;
    --state) STATE="${2:-}"; shift 2;;
    --task) TASK="${2:-}"; shift 2;;
    --from) FROM="${2:-}"; shift 2;;
    --to) TO="${2:-}"; shift 2;;
    --msg) MSG="${2:-}"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 1;;
  esac
done

if [[ -z "$AGENT" || -z "$STATE" ]]; then
  echo "Missing required args: --agent and --state" >&2
  usage
  exit 1
fi

case "$STATE" in
  idle|working|sleeping|eating) ;;
  *) echo "Invalid --state: $STATE" >&2; exit 1;;
esac

if ! command -v gh >/dev/null 2>&1; then
  echo "Missing dependency: gh" >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "Missing dependency: jq" >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GIST_CONFIG_PATH="${GIST_CONFIG:-$ROOT_DIR/data/gist-config.json}"

if [[ ! -f "$GIST_CONFIG_PATH" ]]; then
  echo "Missing gist config: $GIST_CONFIG_PATH" >&2
  exit 1
fi

GIST_ID="$(jq -r '.gist_id' "$GIST_CONFIG_PATH")"
if [[ -z "$GIST_ID" || "$GIST_ID" == "null" ]]; then
  echo "Invalid gist_id in $GIST_CONFIG_PATH" >&2
  exit 1
fi

now_iso="$(date -Iseconds)"
now_epoch="$(date +%s)"

# Normalize TASK
jq_task='null'
if [[ -n "$TASK" && "$TASK" != "null" ]]; then
  jq_task=$(jq -Rn --arg t "$TASK" '$t')
fi

feed_item='null'
if [[ -n "$FROM" || -n "$TO" || -n "$MSG" ]]; then
  if [[ -z "$FROM" || -z "$TO" || -z "$MSG" ]]; then
    echo "If providing feed fields, must set all: --from --to --msg" >&2
    exit 1
  fi
  # id: <epoch>-<from>-<rand4>
  rand4="$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 4 || true)"
  feed_id="${now_epoch}-${FROM}-${rand4}"

  feed_item=$(jq -n \
    --arg id "$feed_id" \
    --argjson ts "$now_epoch" \
    --arg from "$FROM" \
    --arg to "$TO" \
    --arg text "$MSG" \
    '{id:$id, ts:$ts, from:$from, to:$to, kind:"msg", text:$text}')
fi

# Fetch gist JSON
live_json="$(gh api "gists/${GIST_ID}" --jq '.files["live.json"].content')"

updated_json="$(jq -c \
  --arg agent "$AGENT" \
  --arg state "$STATE" \
  --arg nowIso "$now_iso" \
  --argjson nowEpoch "$now_epoch" \
  --argjson task "$jq_task" \
  --argjson feedItem "$feed_item" \
  '(.generatedAt = $nowIso)
   | (.agents[$agent].state = $state)
   | (.agents[$agent].task = $task)
   | (.agents[$agent].since = $nowEpoch)
   | (if $feedItem != null then .feed = (.feed + [$feedItem]) else . end)
   | (.feed = (.feed[-100:]))
  ' <<<"$live_json")"

payload_path="$(mktemp)"
jq -n --arg content "$updated_json" '{files:{"live.json":{content:$content}}}' > "$payload_path"

# PATCH update (atomic enough for our use)
gh api "gists/${GIST_ID}" -X PATCH --input "$payload_path" >/dev/null

rm -f "$payload_path"

echo "Updated gist $GIST_ID: agent=$AGENT state=$STATE" >&2
