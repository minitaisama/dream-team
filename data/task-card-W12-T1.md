## Task Card — W12-T1

### Core
- **Task:** Dream Team Retro Dashboard UX Overhaul
- **Goal:** Make the dashboard feel like a professional product dashboard — not a dev side project. Fix accessibility, add branding, improve visual hierarchy.
- **Dependencies:** UX audit report at `data/ux-audit-report.md` (complete)
- **Scope:**
  - Fix all WCAG AA color contrast failures (specific selectors in audit report)
  - Add favicon (use penguin illustration from Taisama — file at `/Users/agent0/.openclaw/media/inbound/file_10---830194db-337a-47df-8b7e-0f0ff38ee35b.jpg`)
  - Add logo in header (penguin icon + "Dream Team Retro" text lockup)
  - Fix heading hierarchy (h1 → h2 → h3 proper order)
  - Add `<main>` landmark
  - Boost stat card values to #ffffff for max contrast
  - Upgrade section headers with left accent border
  - Add proper `<title>`, OG meta tags
  - Add footer links (GitHub repo, playbook)
  - Mobile optimization (stat cards, agent cards)
- **Non-goals:**
  - No JSON data structure changes
  - No new features (filters, search)
  - No framework migration
  - No Chart.js replacement
- **Acceptance:**
  - Lighthouse accessibility score ≥ 95
  - Zero contrast failures
  - Favicon loads (no 404)
  - Proper heading hierarchy (WAVE: "heading structure found")
  - `<main>` landmark present
  - Logo visible in header
  - Mobile looks good at 375px
- **DoD:** All P0 + P1 from audit report fixed, deployed to Vercel, Lighthouse re-run confirms

### CEO Direction
- Reframe: "fix colors" → professional product dashboard
- Scope mode: selective expansion
- Brand: penguin illustration is Taisama's avatar

### Design Requirements
- **Color palette (updated):**
  - `--bg`: `#0a0a0f` (keep)
  - `--surface`: `#12121a` (keep)
  - `--surface2`: `#1a1a26` (keep)
  - `--text`: `#e8e8ec` (up from `#e4e4e7`)
  - `--text2`: `#b8b8c4` (up from `#a1a1aa`)
  - `--text3`: `#8b8b99` (up from `#71717a`)
  - `--accent`: `#8b5cf6` (keep)
  - `--ceo`: `#f59e0b` (keep)
  - Stat values: `#ffffff`
- **Interaction states:** N/A (static dashboard, no loading state needed)
- **Responsive:** 375px / 768px / 1280px

### Risk
- Favicon from illustration: simplify to work at 16/32px. Use image tool to resize/crop.
- Verify contrast after changes with Lighthouse re-run.
