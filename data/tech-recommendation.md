# Dreamteam At Work — lightweight “live” dashboard tech recommendation

## Executive choice (pick ONE)
**Go with A) File-based + client polling** — but **host the `live.json` outside the Vercel deployment** so updates don’t require redeploys.

**Concrete implementation:**
- Store a single JSON file (`live.json`) in a **GitHub Gist** (or a dedicated “data” repo/branch served via raw URL).
- **OpenClaw updates the JSON via GitHub API** on events (agent status change, new message, task start/end).
- The Vercel static site **polls** the raw JSON every **30–60s** (plus “manual refresh” button).

Why this over B/D:
- **Simplest** (no server runtime, no KV provisioning, no streaming timeouts).
- **Reliable on free tiers** (polling tolerates function cold starts, network hiccups, etc.).
- **Latency target fits** (30–60s is explicitly acceptable).

Notes / gotchas (and how to handle them):
- **Caching:** fetch with a cache-buster querystring, e.g. `live.json?ts=${Date.now()}` and set `cache: 'no-store'`.
- **Atomicity:** OpenClaw writes the full JSON in one PATCH (Gist update is atomic enough for this use).
- **Rate limits:** keep updates coarse (batch events, debounce to e.g. 1 write per 5–10s max).

---

## 2) Pixel animation (pick ONE)
**Go with A) CSS sprites + keyframe animation.**

Why:
- **Very lightweight** (no canvas render loop, no engine).
- **Great pixel fidelity** (crisp nearest-neighbor scaling).
- Interactivity is “enough”: the dashboard can switch states by toggling CSS classes from the polled `live.json`.

Implementation sketch:
- Prepare sprite sheets per character with rows for states: `idle | run | sleep | eat`.
- Use `background-position` + `steps(n)` keyframes for frame animation.
- For movement, use a second keyframe on `transform: translate(...)` when “active”.
- Add `image-rendering: pixelated;`.

File-size strategy:
- Prefer **PNG sprite sheets** over GIFs for smaller size + better control.
- Keep frame counts low (e.g., idle: 2–4, run: 6–8, sleep: 2–4, eat: 3–5).

---

## 3) Agent chat / activity feed

### Storage
Keep **everything in one `live.json`** (single fetch, single mental model). Structure it so the UI can render multiple widgets.

Recommended shape (minimal but extensible):
```json
{
  "version": 1,
  "generatedAt": "2026-03-19T00:10:00+07:00",
  "agents": {
    "coach": { "state": "idle", "task": null, "since": 1710000000 },
    "pm":    { "state": "working", "task": "Spec v2", "since": 1710000100 },
    "dev":   { "state": "working", "task": "Implement polling", "since": 1710000200 },
    "qa":    { "state": "sleeping", "task": null, "since": 1710000300 }
  },
  "feed": [
    {
      "id": "1710000250-dev-1",
      "ts": 1710000250,
      "from": "coach",
      "to": "dev",
      "kind": "handoff",
      "text": "Task card ready — start building the polling loop."
    }
  ]
}
```

### Max messages
**Keep the last 80–120 messages** (I’d pick **100**) as a ring buffer.
- Enough to feel “alive” without bloating the JSON.
- UI can optionally show only last 30 with a “load more” button.

### “Human-like” message generation
Keep it **template-driven** (cheap, consistent, safe):
- Define 10–20 templates per `kind` (handoff, status, question, blocker, review, celebration).
- Randomize synonyms + add tiny variability (ETA minutes, short reactions).
- Keep it punchy (1 sentence) and let the UI add personality (typing indicator, timestamps, avatars).

Example template set (handoff):
- "{from} → {to}: Task card ready — start on {task}."
- "{to}, you’re up: {task}. Ping if blocked."
- "Green light on {task}. Go." 

If you already have an LLM in OpenClaw and want more flavor, you can **optionally** generate free-form text, but still wrap it in a constrained schema and clamp length.

---

## 4) Overall architecture

### Repo file structure (frontend)
```txt
/
  index.html
  /src
    app.js                # polling + state store + rendering
    store.js              # merge + diff helpers
    ui/
      agents.js           # agent cards
      feed.js             # chat/activity feed
      pixel-scene.js      # toggles CSS classes based on agent state
  /public
    /sprites
      coach.png
      pm.png
      dev.png
      qa.png
    /styles
      base.css
      dashboard.css
      sprites.css
  /data
    live.schema.json      # optional: schema for validation
    demo.live.json        # fallback when offline / local demo
```

### “Writer” side (OpenClaw)
Not in the Vercel repo necessarily; it can live in your automation scripts:
- `scripts/update-live-json.ts` (or Python) that:
  1) reads current `live.json` from the Gist
  2) applies updates (agent states + append feed message)
  3) trims feed to last 100
  4) writes back via GitHub API

### Data flow diagram (ASCII)
```txt
        (events: task start/end, agent msg)
+------------------+
|  OpenClaw runner  |
|  (on your host)   |
+---------+--------+
          |
          | PATCH (GitHub API)
          v
+---------------------------+
| GitHub Gist: live.json    |
| (single source of truth)  |
+-------------+-------------+
              |
              | GET (raw URL) every 30–60s
              v
+---------------------------+
| Vercel static site        |
| (JS polling + render)     |
+---------------------------+
```

### Frequencies / timing
- **Client polling:** 30s default (configurable to 60s).
- **Writer updates:** event-driven but debounced (e.g., batch multiple events into one write every 5–10s).
- **UI smoothing:** if no update arrives, keep animations in last-known state; show “last updated Xs ago”.

### What stays on Vercel vs external
- **On Vercel (static):** HTML/CSS/JS, sprite assets, demo JSON, all rendering.
- **External (minimal):** a single JSON blob in GitHub Gist (or equivalent file hosting) updated by OpenClaw.

---

## Summary
- **Live mechanism:** A) polling a remotely hosted `live.json` (Gist) — simplest, fits free tiers, 30–60s lag is acceptable.
- **Pixel scene:** CSS sprite sheets + keyframes; UI just flips classes based on agent state.
- **Feed:** keep last ~100 messages inside `live.json`; template-driven text for human vibe.
- **Architecture:** static Vercel frontend + OpenClaw “writer” pushing JSON updates to a file host.
