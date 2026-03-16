# DreamTeam 2.0

A lightweight multi-agent operating model for software work.

Core roles:
- **Coach** (`pm-agent`) — scope, task framing, workflow, release gate
- **Lebron** (`code-agent`) — implementation and local execution
- **Curry** (`qa-agent`) — independent validation and release confidence

This repo contains the public docs/runbooks for the current DreamTeam 2.0 setup.

---

## What this project is

**DreamTeam 2.0** is the current public name of the project.
It grew out of the earlier internal name **Dream Team**.

The rename is intentional:
- **Dream Team** described the original idea of a small role-based agent trio
- **DreamTeam 2.0** signals that the project is now a more opinionated second-generation operating model
- it is lighter, more Codex-friendly, and much more explicit about token efficiency than the earlier framing

In short:
- **Dream Team** = the original concept
- **DreamTeam 2.0** = the refined public runbook

DreamTeam 2.0 is a practical operating model for running software work across a small set of specialized roles without turning every task into process theater.

The goal is simple:
- keep planning clear
- keep implementation fast
- keep QA independent when needed
- keep token burn low
- keep ownership obvious

DreamTeam 2.0 is intentionally **lightweight**.
It is not trying to be a huge framework or a prompt zoo.
It is a small runbook for getting real work done with clear handoffs.

---

## Inspiration

This project was strongly inspired by **gstack** by Garry Tan:
- repo: <https://github.com/garrytan/gstack>

What gstack got very right:
- explicit workflow gears instead of one mushy assistant mode
- specialized roles/modes for different jobs
- treating AI work as workflow orchestration, not just prompting
- making planning, review, QA, and shipping feel like distinct operating modes

That was the spark.

But DreamTeam 2.0 is **not a copy** of gstack.
It takes the core insight and adapts it to a different environment, different tooling assumptions, and a different set of lessons learned from real project work.

---

## Why DreamTeam 2.0 exists

After running real projects, a few patterns kept repeating:

- coding agents moved too early before scope was frozen
- multiple agents overlapped on the same analysis
- QA sometimes validated a moving target
- long chat handoffs wasted tokens
- full history forwarding made runs expensive and noisy
- one-model-does-everything workflows felt convenient but degraded quality

DreamTeam 2.0 exists to solve those problems with a simpler model.

---

## What changed from the original inspiration

Compared with the original inspiration, this project intentionally changed several things.

### 1. From model-centric to stage-centric
Instead of building around one model personality, DreamTeam 2.0 is built around **stages of work**:
- framing
- execution
- validation
- release decision

Roles are stable.
Model/provider can change.

### 2. Codex support is first-class
DreamTeam 2.0 explicitly treats **Codex** as the default executor for well-scoped coding work.

That means:
- vague asks should not go straight to the executor
- Coach must freeze a tiny task card first
- prompts should be short, bounded, and execution-oriented
- long Claude-style prose prompts should not be ported 1:1

### 3. Lightweight over elaborate
The original inspiration showed the power of explicit modes.
DreamTeam 2.0 pushes that further toward **minimum viable process**.

Only 3 modes are kept:
- **Solo**
- **Build** (default)
- **Release-critical**

This repo deliberately avoids adding too many extra gears.

### 4. Artifact-first handoffs
Instead of “see thread above,” DreamTeam 2.0 prefers:
- tiny task cards
- changed files
- verify results
- concise QA outputs
- compact artifact paths when needed

### 5. Token burn is treated as a first-class design constraint
DreamTeam 2.0 was redesigned around a harsh reality:
most waste does **not** come from hard tasks.
It comes from:
- re-explaining context
- duplicate analysis
- forwarding long histories
- verbose inter-agent chatter

So the runbook now optimizes for **quality per token**, not just quality in the abstract.

---

## What DreamTeam 2.0 improves over the source inspiration

### Improvement 1 — Better fit for Codex-style execution
DreamTeam 2.0 makes Codex the default bounded executor instead of assuming a Claude-shaped workflow.

### Improvement 2 — Simpler operating model
Instead of many cognitive modes, DreamTeam 2.0 reduces the core workflow to 3 practical modes:
- small task
- normal build
- high-risk release

### Improvement 3 — Stronger PM / QA separation
DreamTeam 2.0 makes this explicit:
- **Lebron can finish implementation**
- **Curry decides confidence**
- **Coach decides ship / hold**

This reduces “done but not actually safe” outcomes.

### Improvement 4 — Better handoff discipline
DreamTeam 2.0 uses tiny task cards and fixed response contracts so roles do less re-interpretation.

### Improvement 5 — Lower token burn
DreamTeam 2.0 aggressively avoids:
- full-thread forwarding
- repeated cross-role analysis
- narrative-heavy handoffs
- broad QA on every task

### Improvement 6 — Derived from real failures, not just elegant theory
The runbook was updated after real project pain:
- scope drift
- QA drift
- retrieval/data-shape confusion
- duplicated multi-agent analysis
- expensive context reloads

So the model is less romantic and more battle-tested.

---

## DreamTeam 2.0 at a glance

### Mode A — Solo
Use when:
- task is small
- scope is clear
- independent QA is unnecessary

Flow:
- Coach handles directly or sends one bounded task to Lebron

### Mode B — Build (default)
Use when:
- code changes are needed
- risk is moderate
- lightweight independent QA is useful

Flow:
1. Coach writes tiny task card
2. Lebron implements + locally verifies
3. Curry validates changed surface only when needed
4. Coach synthesizes one update

### Mode C — Release-critical
Use when:
- auth/payment/core-flow changes
- blast radius is high
- release confidence matters

Flow:
1. Coach freezes scope
2. Lebron builds
3. Curry validates changed path + one regression path
4. Coach decides `ship | ship_with_risk | hold`

---

## Core runbook rules

### Tiny task card is mandatory
```text
Task:
Goal:
Scope:
Non-goals:
Acceptance:
Risk focus:
```

### Default handoff philosophy
- short
- explicit
- bounded
- no essay-style backstory unless needed for correctness

### QA philosophy
- validate the fixed contract
- changed surface by default
- full regression only when risk justifies it

### Token philosophy
- no full history forwarding by default
- no duplicate analysis by multiple roles without reason
- updates only when state changed
- artifacts beat long transcripts

---

## Hard learnings behind this runbook

1. **Never code before scope is frozen**
2. **Parallelism only helps after clean decomposition**
3. **QA must validate a fixed contract**
4. **Many failures are parser/data/env issues, not pure code issues**
5. **Artifact beats transcript**
6. **Most token waste comes from re-explaining**

These are the reasons the project looks the way it does now.

---

## Repo contents

- `dream_team_v2.md` — current lightweight runbook
- `agents/pm-agent/AGENT.md` — Coach prompt/role doc
- `agents/code-agent/AGENT.md` — Lebron prompt/role doc
- `agents/qa-agent/AGENT.md` — Curry prompt/role doc

---

## Example run: Layer 4 retrospective (old runbook vs DreamTeam 2.0)

One of the clearest real-world inputs for DreamTeam 2.0 came from the earlier **Tu Vi Layer 4** work.

That work exposed a few recurring problems in the older operating style:
- scope was not frozen early enough
- PM, engineering, and QA often re-analyzed the same problem
- long-thread context kept getting replayed
- QA sometimes validated an evolving target instead of a fixed contract
- token burn grew much faster than delivery quality

DreamTeam 2.0 was designed to fix exactly that.

### Real retrospective summary

Based on archived Layer 4 work, several major turns landed in the **~167k to ~205k token** range by themselves.
That makes the old style expensive very quickly once a task requires multiple reframes, clarifications, and review loops.

The biggest lessons from that retrospective were:
- split work into explicit micro-slices early
- freeze a tiny spec before coding
- validate against a fixed contract
- classify failures before recoding (`parser`, `scorer`, `corpus/data-shape`, `infra/env`, or real code bug)
- stop paying for repeated re-explanation

### Before vs after

| Dimension | Old runbook (Layer 4 style) | DreamTeam 2.0 |
|---|---:|---:|
| Typical operating shape | PM-heavy, evolving thread, overlapping analysis | Fixed task card, bounded execution, lean QA |
| Typical large-turn range | ~167k–205k tokens | much smaller bounded turns |
| Estimated total task burn | ~580k–760k tokens | ~220k–340k tokens |
| Estimated token savings | — | ~360k–420k tokens saved |
| Estimated reduction | — | ~55%–70% lower |
| Most realistic planning midpoint | ~650k | ~280k |
| Midpoint reduction | — | ~57% lower |

### What changes operationally

With the old runbook:
- the system often kept discussing the problem while building it
- PM, executor, and QA overlapped more than they should
- context forwarding was too expensive
- progress reports were sometimes more narrative than necessary

With DreamTeam 2.0:
- **Coach** freezes the problem earlier
- **Lebron/Codex** gets a bounded task instead of a long evolving brief
- **Curry** validates the changed surface against a fixed contract
- inter-agent handoffs stay extremely small
- updates only happen on real state changes (`started`, `blocked`, `risk found`, `finished`)

### Why the new model is better

DreamTeam 2.0 improves the same kind of work by making it:
- **cheaper** — far less token waste from re-reading and overlap
- **clearer** — role ownership is sharper
- **safer** — QA becomes a real gate, not a loose afterthought
- **more Codex-friendly** — bounded execution fits Codex much better than long ambiguous threads
- **more scalable** — artifacts and contracts carry the work, not giant transcripts

### Short takeaway

For Layer 4-style work, DreamTeam 2.0 is expected to preserve quality while cutting token burn by roughly **55%–70%**, with a practical planning assumption of about **57% savings**.

---

## Current status

DreamTeam 2.0 is the current active model.

Its priorities are:
- lightweight execution
- Codex-friendly handoffs
- strict role ownership
- better QA gating
- aggressive token efficiency

---

## Short version

**DreamTeam 2.0 is a lightweight stage-based system where Coach freezes the problem, Lebron/Codex executes bounded work fast, Curry validates with evidence when needed, and every handoff is kept brutally small to minimize token burn.**
