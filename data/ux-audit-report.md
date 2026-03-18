## UX Audit Report — dreamteam20.vercel.app

Audit date: 2026-03-18 (GMT+7)

Artifacts saved:
- Lighthouse HTML report: `/Users/agent0/dreamteam2.0/data/lighthouse-report.report.html`
- Lighthouse JSON report: `/Users/agent0/dreamteam2.0/data/lighthouse-report.report.json`
- Lighthouse screenshot: `/Users/agent0/dreamteam2.0/data/lighthouse-results-screenshot.jpg`

### Lighthouse
- Accessibility score: **83**
- Performance score: **96**
- Best Practices score: **96**

Lab performance metrics (from Lighthouse run):
- FCP: **2.0s**
- LCP: **2.0s**
- Speed Index: **4.0s**
- Total Blocking Time: **0ms**
- CLS: **0**

Specific failures / issues (key ones):
- **Color contrast fails** (score 0)
  - Pattern: low-contrast gray text `#71717a` on dark backgrounds (`#12121a`, `#0a0a0f`, `#1a1a26`) not meeting **4.5:1**.
  - Worst groups (unique selectors):
    - `div#actionList > div.action-item > div > span.owner` (e.g., “coach/lebron/curry”) — **3.56:1** (needs 4.5:1)
    - `div.container > div#statsGrid > div.stat-card > div.stat-label` (e.g., “TASKS DONE”, “QUALITY”, etc.) — **3.85:1**
    - `div.container > div#statsGrid > div.stat-card > div.stat-change` (e.g., “across 3 agents”, “from CEO review”) — **3.85:1**
    - `div.container > div.header > div > div.subtitle` (repo subtitle “minitaisama/dreamteam2.0”) — **4.08:1**
    - `body > div.container > div.footer` (footer line) — **4.08:1**
    - `div.agent-header > div > div.agent-name > span.agent-badge` (e.g., “PM” badge) — **4.25:1**
- **Heading structure issues**
  - “Heading elements are not in a sequentially-descending order” (score 0)
  - Example flagged: `body > div.container > div#actionItems > h3` (“📋 Action Items”) suggests missing/incorrect H1/H2 structure above.
- **Missing landmark**
  - “Document does not have a main landmark” (score 0) — page lacks a `<main>` landmark.
- **Best Practices: console errors** (score 0)
  - 404: `https://dreamteam20.vercel.app/favicon.ico`
- Performance opportunities / insights called out:
  - **Render blocking requests** — est. savings **~1,190ms**
  - **Reduce unused JavaScript** — est. savings **~30KiB** (overallSavingsMs ~170ms)
  - **Use efficient cache lifetimes** — est. savings **~7KiB**
  - “Network dependency tree” insight
  - “LCP breakdown” insight

### Wave
Source: https://wave.webaim.org/report?url=https://dreamteam20.vercel.app

- Contrast failures:
  - **None reported by WAVE** (page shows the contrast panel, but no explicit contrast-error icons were detected in the fetched output).
  - Note: WAVE warns it may not detect contrast issues with gradients/filters/transparency; Lighthouse *did* detect multiple contrast failures.
- ARIA issues:
  - **None reported** in the fetched WAVE summary.
- HTML / semantic issues:
  - **“This page has no heading structure!”**

### PageSpeed
Source requested: https://pagespeed.web.dev/analysis?url=https%3A%2F%2Fdreamteam20.vercel.app

- Core Web Vitals:
  - Unable to reliably extract PSI’s CWV numbers via `web_fetch` (PageSpeed is JS-rendered; the readable extraction returned only a “Running analysis / data loading” shell).
  - Attempting to use the public PageSpeed API endpoint failed with a **429 quota exceeded** error.
  - **Best available proxy (lab):** Lighthouse metrics above (LCP 2.0s, CLS 0, TBT 0ms).
- Opportunities:
  - Use Lighthouse “Opportunities / Insights” list above (render-blocking, unused JS, caching, dependency chain, LCP breakdown).

### Summary — Priority Fixes
Ranked by impact (P0 → P2). Includes what’s wrong, where, recommended fix.

**P0 (critical)**
1) **Fix text contrast across the UI**
   - What’s wrong: multiple text elements are below WCAG AA **4.5:1** contrast.
   - Where: stats labels/changes, action item owner/due text, header subtitle, footer, badge text (see selectors in Lighthouse section).
   - Fix: bump `--text3` (or equivalent token) lighter, or darken card backgrounds; verify with a contrast checker at smallest font sizes (12–14px). Consider defining AA-compliant token pairs per surface (page bg vs card bg).

**P1 (important)**
2) **Add a real semantic heading hierarchy**
   - What’s wrong: WAVE indicates “no heading structure”; Lighthouse flags heading order issues.
   - Where: main page content; “📋 Action Items” appears as an `h3` without prior `h1/h2`.
   - Fix: add an `h1` (page title), use `h2` for major sections (Stats, Agents, Action Items, Trends), then `h3` as needed.

3) **Add `<main>` landmark**
   - What’s wrong: no main landmark for screen-reader navigation.
   - Where: document root.
   - Fix: wrap primary content in `<main>` (single instance) and keep header/footer outside.

4) **Fix favicon 404**
   - What’s wrong: console/network error hurts Best Practices and polish.
   - Where: `/favicon.ico`.
   - Fix: add favicon to public assets (or update `<link rel="icon">` to an existing asset).

**P2 (nice-to-have)**
5) **Reduce render-blocking + trim unused JS**
   - What’s wrong: Lighthouse estimates ~1.19s savings from render-blocking resources; ~30KiB unused JS.
   - Where: initial load critical path.
   - Fix: defer non-critical scripts, split bundles, ensure CSS is minimal/critical, leverage Next.js dynamic imports, and set long-lived caching for static assets.
