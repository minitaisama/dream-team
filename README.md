# DreamTeam 2.0

```text
User ask
   |
   v
 Coach
(scope / task card / gate)
   |
   +--------> Solo ------------------------------+
   |                                             |
   v                                             v
 Lebron ----------------------------------> final update
(build / verify)                                ^
   |                                            |
   v                                            |
 Curry (when needed) ---------------------------+
(QA / risk / ship-hold)
```

A lightweight operating model for AI-assisted software work.

---

## Inspiration & profiles

DreamTeam 2.0 is mainly inspired by two strong open-source directions:

### Garry Tan / gstack
- Repo: <https://github.com/garrytan/gstack>
- Why it matters: strong workflow abstraction, explicit modes, builder-facing orchestration

### 666ghj (BaiFu) / BettaFish
- Repo: <https://github.com/666ghj/BettaFish>
- Why it matters: strong product framing, clear engine decomposition, structured outputs, great demoability

DreamTeam 2.0 does **not** copy either system directly.
It takes workflow clarity from **gstack** and product/structure lessons from **BettaFish**, then compresses them into a lighter runbook.

---

## What DreamTeam 2.0 is

DreamTeam 2.0 is a small runbook for running software work with AI agents without turning every task into process theater.

It is optimized for:
- **Codex-first execution**
- **lightweight handoffs**
- **clear role ownership**
- **quality per token**

Core roles:
- **Coach** (`pm-agent`) — scope, task framing, release gate
- **Lebron** (`code-agent`) — implementation and local execution
- **Curry** (`qa-agent`) — independent validation and release confidence

Default modes:
- **Solo**
- **Build**
- **Release-critical**

---

## Why “2.0”

The earlier internal framing was **Dream Team**.

**DreamTeam 2.0** means the public refined version:
- lighter
- more Codex-friendly
- stricter about QA gates
- more explicit about token efficiency

In short:
- **Dream Team** = original concept
- **DreamTeam 2.0** = refined public runbook

---

## Core principles

- freeze scope before coding
- use tiny task cards
- keep handoffs brutally short
- validate a fixed contract, not an evolving target
- use the lightest mode that still preserves quality
- optimize for **quality per token**

---

## Repo map

- [`dream_team_v2.md`](./dream_team_v2.md) — main runbook
- [`ARTIFACTS.md`](./ARTIFACTS.md) — artifact definitions
- [`QA_PLAYBOOK.md`](./QA_PLAYBOOK.md) — lightweight QA rules
- [`EXAMPLES.md`](./EXAMPLES.md) — canonical examples
- [`handoff_contracts.md`](./handoff_contracts.md) — compact handoff formats

---

## English

DreamTeam 2.0 is a lightweight stage-based runbook where Coach freezes the problem, Lebron executes bounded work fast, Curry validates with evidence when needed, and every handoff stays small to minimize token burn.

## Tiếng Việt

DreamTeam 2.0 là một runbook stage-based gọn nhẹ: Coach chốt bài toán trước, Lebron execute bounded work nhanh, Curry validate bằng evidence khi cần, và mọi handoff đều được giữ rất nhỏ để giảm token burn.

## 中文

DreamTeam 2.0 是一个轻量级、stage-based 的 runbook：Coach 先冻结问题，Lebron 快速执行有边界的工作，Curry 在需要时基于证据做验证，而所有 handoff 都尽量保持很小，以降低 token burn。
