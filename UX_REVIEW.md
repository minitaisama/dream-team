# UX Review — Dream Team Dashboard v2.0

**Reviewer:** Coach (pm-agent)  
**Date:** 2026-03-24  
**URL:** https://dreamteam-by-taisama.vercel.app/  
**Context:** Dashboard cho người dùng orchestrating AI agents daily. CEO (MiniSama) là thành viên quan trọng nhất.

---

## Summary

Dashboard có foundation tốt: dark theme consistent, layout logic, collapsible sections, responsive. Tuy nhiên có **10 critical/high issues** cần ưu tiên fix, chủ yếu xoay quanh: (1) contrast trên dark theme, (2) empty states thiếu guidance, (3) mobile navigation ambiguity, (4) content clarity cho labels chuyên ngành, (5) visual hierarchy cho CEO card.

---

## Top 10 Issues Cần Fix Gấp

### 1. 🔴 CEO Card chưa đủ prominent — cần là focal point rõ ràng nhất
- **Severity:** critical
- **Section:** MiniSama CEO Card (top of main content)
- **Detail:** CEO card dùng `border-2 border-primary/30` + gradient nhẹ, nhưng nằm cùng row với KPIs và không có visual weight đủ khác biệt so với agent cards bên dưới. Eye bị phân tán giữa KPI row → CEO card → agent grid.
- **Suggestion:**
  - Tăng gradient opacity: `rgba(109,59,215,0.15)` → `rgba(109,59,215,0.25)`
  - Thêm subtle glow/shadow: `box-shadow: 0 0 40px rgba(109,59,215,0.15)`
  - Tăng padding: `p-5` → `p-6 md:p-8`
  - Thêm crown icon lớn hơn hoặc animated sparkle cho CEO badge
  - Thêm subtle animated border gradient effect

### 2. 🔴 Bottom nav trên mobile: "Tuần" tab bị nhầm là navigation section
- **Severity:** critical
- **Section:** Mobile bottom nav bar
- **Detail:** Bottom nav có 3 items: "Tổng quan", "Tuần", "Hỗ trợ". "Tuần" thực chất là timeframe toggle (Hôm nay / Tuần), không phải page riêng. User tap "Tuần" rồi vào tab week, nhưng khi quay lại bottom nav, "Tổng quan" vẫn active vì `switchTab('today')` được gọi thay vì `switchTab('week')`. Logic sai hoàn toàn.
- **Suggestion:**
  - Bottom nav nên giữ nguyên 3 sections: Tổng quan, Hiệu suất, Hỗ trợ (map với sidebar desktop)
  - Timeframe toggle (Hôm nay/Tuần) giữ nguyên ở header — không move xuống bottom nav
  - Fix: bottom nav item "Tuần" → `onclick="switchView('insights'); setActiveNav(this)"` thay vì `switchTab('week')`
  - Mỗi nav item active state cần sync đúng với header tab state

### 3. 🔴 Contrast ratio fail trên nhiều text elements
- **Severity:** critical
- **Section:** Toàn page (đặc biệt: secondary text, labels, agent card status)
- **Detail:** Màu `on-surface-variant: #cbc3d7` trên background `surface-container: #1e1f26` cho contrast ~4.8:1 — borderline WCAG AA. Nhưng nhiều chỗ dùng `text-[10px]` và `text-[9px]` khiến readability thực tế rất kém. Labels như "MỚI NHẤT", "Git", branch info gần như unreadable trên mobile.
- **Suggestion:**
  - Bump `on-surface-variant` lên `#d8d2e6` (contrast ~5.8:1)
  - Minimum text size: `text-[10px]` → `text-[11px]` cho labels, `text-[9px]` → `text-[10px]` cho micro-labels
  - Agent card status badge `text-[10px]` → `text-[11px]`
  - KPI label `text-[10px]` → `text-xs` (12px)
  - Project health `text-[9px]` uppercase labels → `text-[10px]`

### 4. 🔴 "Resolution SLA" — người dùng không hiểu label này
- **Severity:** high
- **Section:** Resolution SLA section (bottom of Today view)
- **Detail:** "Resolution SLA" là thuật ngữ IT/DevOps, user orchestrating AI agents có thể không hiểu. Empty state chỉ hiện "Chưa có dữ liệu SLA" — không giải thích SLA là gì hay user nên làm gì.
- **Suggestion:**
  - Rename → "Thời gian xử lý" hoặc "Tốc độ xử lý vấn đề" (nearer Vietnamese)
  - Hoặc giữ SLA nhưng thêm tooltip: `<span title="SLA = Service Level Agreement — cam kết thời gian xử lý">SLA ⓘ</span>`
  - Empty state thêm CTA: "SLA sẽ tự động cập nhật khi có action items được resolve. [Tìm hiểu thêm]"
  - Boxes label "24h", "48h", "1 tuần", "Quá hạn" → OK nhưng thêm subtitle giải thích: "Đã xử lý trong 24h"

### 5. 🔴 Health Score 50 cho TẤT CẢ agents — meaningless
- **Severity:** high
- **Section:** Agent cards + CEO card
- **Detail:** Mọi agent đều hiển thị health score = 50. Khi tất cả bằng nhau, metric mất hoàn toàn giá trị. User không biết 50 là tốt/xấu hay neutral. Không có legend hay explanation.
- **Suggestion:**
  - Thêm tooltip/hover text: "50/100 — Trạng thái bình thường" (hoặc description gì đó meaningful)
  - Nếu data thực sự chưa có, tốt hơn là hiện "N/A" hoặc dash thay vì số giả
  - Thêm legend section hoặc info icon: "Health Score = tổng hợp task completion, response time, quality. 70+ = Tốt, 40-69 = Bình thường, <40 = Cần chú ý"
  - Circle SVG thêm `role="img" aria-label="Health score: 50/100"`

### 6. 🟡 Collapsible sections mặc định collapsed — user không biết có content bên trong
- **Severity:** high
- **Section:** Daily Retro, Action Items, Feedback gần đây
- **Detail:** 3 accordion sections collapsed mặc định, không có count badge hay preview. User phải mở từng cái để xem có gì — friction cao cho daily glance. Đặc biệt "Action Items" là thứ quan trọng nhất cần see-at-a-glance.
- **Suggestion:**
  - Action Items: **mặc định mở** (default expanded) — đây là thứ cần action mỗi ngày
  - Thêm count badge bên cạnh mỗi accordion title: `Action Items (5)`, `Feedback gần đây (2)`
  - Thêm 1-line preview khi collapsed: "5 items mở · 2 carried over"
  - Daily Retro: giữ collapsed OK, nhưng hiện quality badge (đã có) + 1-line summary

### 7. 🟡 Empty states quá generic, thiếu guidance
- **Severity:** high
- **Section:** SLA ("Chưa có dữ liệu SLA"), Feedback ("Chưa có feedback"), Retro ("Chưa có retro cho ngày này")
- **Detail:** Tất cả empty states đều dùng pattern: icon + 1 dòng text. Không có CTA, không có explanation, không có next-step guidance. User thấy và... rời đi.
- **Suggestion:**
  - Pattern mới cho empty states:
    ```html
    <div class="flex flex-col items-center py-10 text-center">
      <span class="material-symbols-outlined text-4xl text-outline-variant/30 mb-3">inbox</span>
      <p class="text-sm text-on-surface-variant font-medium">Chưa có feedback</p>
      <p class="text-xs text-on-surface-variant/60 mt-1 max-w-xs">Feedback sẽ xuất hiện khi agents giao tiếp trong retro hoặc code review.</p>
    </div>
    ```
  - Retro empty: thêm "Chọn ngày khác hoặc đợi retro cron chạy lúc 23:59"
  - SLA empty: thêm "SLA track khi action items được resolve"

### 8. 🟡 KPI row — 3/5 values = 0, tạo cảm giác "dead dashboard"
- **Severity:** high
- **Section:** KPI Row (top of Today view)
- **Detail:** "0 Hoàn thành", "0 Bị chặn", "8 Action mới", "0 Agent", "0 Tokens". 60% KPIs bằng 0. Khi chưa có activity trong ngày, dashboard trông vô hồn và user có thể nghĩ data bị lỗi.
- **Suggestion:**
  - Thêm subtle "no data" visual treatment cho zeros: text color `text-outline-variant` thay vì bold white
  - Thêm time context: "0 · chưa có activity hôm nay"
  - "0 Agent" → nên clarify: "0/7 Agent hoạt động" (hiển thị luôn total)
  - "0 Tokens" → nếu thực sự 0, hiện dash "—" thay vì 0 để tránh confusion
  - Consider thêm "streak" hoặc "last activity" indicator để dashboard không trông dead

### 9. 🟡 "Improvement Velocity" label — ambiguous
- **Severity:** medium
- **Section:** Week view — "Tốc độ cải thiện" section
- **Detail:** Label "📈 Tốc độ cải thiện" + English "Improvement Velocity" trong code. Chart hiển thị stacked bars (Observing/Promoted/Rules) nhưng không có y-axis labels, không có tooltip khi hover, không giải thích bars mean gì.
- **Suggestion:**
  - Rename → "Tiến trình bài học" (nearer "Lesson Progress") — chính xác hơn với data thực tế
  - Thêm y-axis labels hoặc at least max value indicator
  - Thêm hover tooltip cho mỗi bar: "Tuần 03/17: 3 Observing, 2 Promoted, 1 Adopted"
  - Legend icons nên to hơn và rõ hơn

### 10. 🟡 pkm-auction project: "Mới nhất: null" — broken data display
- **Severity:** medium
- **Section:** Sức khỏe dự án — pkm-auction row
- **Detail:** Newest file hiển thị literal string "null" thay vì fallback text. Đây là bug data rendering.
- **Suggestion:**
  - Fix: `esc(p.newestFile || '—')` đã có fallback `—` nhưng data trả về string "null" (not null). Thêm: `esc(p.newestFile && p.newestFile !== 'null' ? p.newestFile : '—')`
  - Audit toàn bộ data pipeline để ensure null values được handle đúng

---

## Full Issue List (All Severities)

### Information Architecture

#### 11. Section order acceptable nhưng Action Items nên được ưu tiên hơn
- **Severity:** medium
- **Section:** Today view layout
- **Detail:** Thứ tự hiện tại: KPIs → CEO Card → Agents → Projects → Retro → Action Items → Feedback → SLA. Action Items (thứ cần user action mỗi ngày) nằm thứ 6/8 — quá sâu.
- **Suggestion:** Move Action Items lên ngay sau KPIs hoặc ngay sau CEO card. Projects có thể move xuống dưới retro.

#### 12. "Hiệu suất" nav item — chưa có view riêng
- **Severity:** medium
- **Section:** Desktop sidebar + Mobile bottom nav
- **Detail:** Nav item "Hiệu suất" (Insights) chỉ link `#`. Tap không làm gì. User expect đi vào analytics/performance view riêng.
- **Suggestion:** Map "Hiệu suất" → switch to Week view (tab-week) + scroll to trends section. Hoặc tạo view riêng.

#### 13. "Hỗ trợ" nav item — dead link
- **Severity:** low
- **Section:** Desktop sidebar + Mobile bottom nav
- **Detail:** Nav item "Hỗ trợ" chỉ là `<a href="#">` không có onclick handler. Dead link.
- **Suggestion:** Wire lên help modal, FAQ section, hoặc ít nhất `#help` anchor. Tạm thời: thêm `onclick="showToast('Tính năng đang phát triển')"`

### Visual Hierarchy

#### 14. KPI cards đều cùng visual weight — không biết đâu quan trọng nhất
- **Severity:** medium
- **Section:** KPI Row
- **Detail:** 5 KPI cards cùng size, cùng style. "8 Action mới" (thực sự có data) không nổi bật hơn "0 Hoàn thành".
- **Suggestion:** KPIs có data > 0 nên có accent border hoặc subtle highlight. Zeros should be muted.

#### 15. Agent cards — tất cả cùng layout, khó phân biệt role
- **Severity:** low
- **Section:** Đội ngũ section
- **Detail:** Coach, Lebron, Bronny, Curry đều cùng card format. Role/function không rõ ràng từ visual. Secondary agents (LaoShi, Mandarin) cũng không khác biệt nhiều.
- **Suggestion:** Thêm subtle role indicator (icon + color) trên mỗi card. Coach = 🧠 purple, Lebron = 💻 green, Bronny = 🎨 amber, Curry = 🔍 blue.

#### 16. Project health bars thiếu visual distinction mạnh
- **Severity:** low
- **Section:** Sức khỏe dự án
- **Detail:** Health bars cho 3 mức (Tốt/Cảnh báo/Lỗi) dùng color difference nhưng cùng height, same style. "Lỗi 20%" bar rất ngắn, khó notice.
- **Suggestion:** Lỗi projects nên có red border-left hoặc red glow. Tốt projects có subtle green left border.

### Readability

#### 17. `text-[9px]` used in multiple places — below minimum readable size
- **Severity:** medium
- **Section:** Nhiều nơi (CEO metrics labels, agent status detail, project grid labels)
- **Detail:** `text-[9px]` ≈ 6.75pt — quá nhỏ để đọc trên mobile, kể cả desktop. Used cho: CEO card metric labels, agent card status detail, project grid column headers, SLA labels, trend chart day labels, lesson filter buttons, velocity legend text.
- **Suggestion:** Global minimum: `text-[10px]` (7.5pt) cho captions, `text-xs` (12px) cho body. Tìm replace: `text-\[9px\]` → `text-\[10px\]` toàn file.

#### 18. Vietnamese + English mixed content — inconsistent tone
- **Severity:** low
- **Section:** Toàn page
- **Detail:** Mix: "Đội ngũ" (VI) + "Has 2 carried action items..." (EN) + "HOẠT ĐỘNG" (VI caps) + "Health" (EN) + "Daily Retro" (EN) + "Feedback gần đây" (VI+EN). Một số agent descriptions bằng tiếng Anh hoàn toàn.
- **Suggestion:** Decide: all Vietnamese hoặc Vietnamese labels + English technical terms. Recommendation: labels = Vietnamese, technical content (agent descriptions, retro items) = keep English (naturally generated). But ensure UI chrome is consistent Vietnamese.

#### 19. Uppercase tracking-widest cho section headings — overkill
- **Severity:** low
- **Section:** "ĐỘI NGŨ", "SỨC KHỎE DỰ ÁN", "RESOLUTION SLA"
- **Detail:** `uppercase tracking-widest` + `text-xs font-bold` cho section headings. Với Vietnamese (có dấu), uppercase looks odd and harder to scan.
- **Suggestion:** Remove uppercase. Use `text-sm font-bold text-on-surface-variant` instead. Vietnamese headings look better in sentence case.

### Interaction Design

#### 20. Date picker — native `<input type="date">` trên mobile, UX kém
- **Severity:** medium
- **Section:** Header — date picker
- **Detail:** Native date input trigger OS picker, nhưng trên mobile nó bị che bởi fixed header + bottom nav. Không có "Today" quick-jump button.
- **Suggestion:** Thêm "Hôm nay" button bên cạnh date picker. Consider custom lightweight date selector cho mobile (show 7 days horizontal scroll).

#### 21. Tab switching "Hôm nay"/"Tuần" — header tabs vs bottom nav conflict
- **Severity:** high
- **Section:** Header tabs + Bottom nav
- **Detail:** Desktop: header tabs "Hôm nay"/"Tuần" hoạt động đúng. Mobile: bottom nav có "Tổng quan"/"Tuần"/"Hỗ trợ" — "Tuần" ở bottom nav gọi `switchTab('week')` nhưng header tabs vẫn hiện "Hôm nay" active. Hai navigation systems conflict.
- **Suggestion:** Unify navigation. Bottom nav = top-level sections. Header = timeframe toggle. When user taps "Tuần" in bottom nav, update header tab active state too. Remove timeframe from bottom nav entirely.

#### 22. Agent cards tap-to-expand — no visual affordance
- **Severity:** medium
- **Section:** Agent cards (Coach, Lebron, Bronny, Curry)
- **Detail:** Cards have `cursor-pointer` và `onclick="this.classList.toggle('expanded')"`, nhưng không có chevron, "more" icon, hay bất kỳ visual cue nào cho biết card expandable. User must discover by accident.
- **Suggestion:** Thêm subtle chevron-down icon ở bottom-right của card. Hoặc "3 dot" menu. Hoặc hint text "Nhấn để xem chi tiết" trên first visit.

#### 23. Collapsible section chevrons — too subtle
- **Severity:** low
- **Section:** Daily Retro, Action Items, Feedback buttons
- **Detail:** Chevron icon `expand_more` ở góc phải, `text-on-surface-variant` (muted gray). Dễ miss, đặc biệt trên mobile.
- **Suggestion:** Chevron color → `text-on-surface` (brighter). Thêm pulse animation khi có new content chưa xem.

### Mobile UX

#### 24. Scroll depth rất dài — 8+ sections stacked
- **Severity:** high
- **Section:** Today view (mobile)
- **Detail:** Full page scroll qua: KPIs → CEO Card → 4 Agent Cards → 2 Secondary Agents → 5 Project Cards → 3 Collapsible Sections → SLA. Estimated 3000-4000px scroll depth. Core action items buried at 70% scroll.
- **Suggestion:**
  - Lazy load sections below fold (Intersection Observer)
  - Projects section: default show top 3 + "Xem thêm (N dự án)"
  - Secondary agents: collapse into horizontal scroll row
  - Consider "quick jump" floating button hoặc sticky section indicators

#### 25. Agent cards 2-col grid trên mobile — too cramped
- **Severity:** medium
- **Section:** Đội ngũ section (mobile)
- **Detail:** `grid-cols-2 gap-3` trên mobile ~390px. Mỗi card ~185px wide. Agent name truncate, status badge overflow, health circle cramped. Text density quá cao cho small tap targets.
- **Suggestion:** Mobile: switch to single column (`grid-cols-1`) cho primary agents. Hoặc horizontal scroll cards. Secondary agents → compact horizontal scroll chips.

#### 26. No "back to top" affordance
- **Severity:** low
- **Section:** Full page
- **Detail:** Sau khi scroll sâu vào projects/retro, không có cách nhanh để quay lại top.
- **Suggestion:** Thêm floating "↑" button khi scroll > 800px.

### Content Clarity

#### 27. Priority P0/P1/P2 badges — cần legend
- **Severity:** medium
- **Section:** Action Items
- **Detail:** P0 (🔴), P1 (🟡), P2 (⚪) badges dùng emoji + tiny text `text-[9px]`. Không giải thích P0 = critical, P1 = high, P2 = medium. Mọi items hiện tại đều P2 → badges become noise.
- **Suggestion:**
  - Thêm info icon + tooltip: "P0 = Khẩn cấp, P1 = Quan trọng, P2 = Cải thiện"
  - Hoặc thêm small legend above action items list
  - Sort action items by priority (P0 first) để badges có meaning

#### 28. Agent descriptions bằng English — user có thể không fluent
- **Severity:** low
- **Section:** Agent cards
- **Detail:** "Has 2 carried action items from 3/23 that need attention", "New action item — connect retro site to real data" — all English. Dashboard labels are Vietnamese.
- **Suggestion:** Đây là generated content, có thể keep English. Nhưng consider adding Vietnamese summary prefix: "⚠️ 2 action items chưa xử lý từ 3/23"

#### 29. "main · 69 tệp" — "tệp" không phổ biến trong dev Vietnamese
- **Severity:** low
- **Section:** Project health cards
- **Detail:** "tệp" = files. Devs thường nói "file" (loanword) trong tiếng Việt dev context.
- **Suggestion:** "tệp" → "files" hoặc giữ "tệp" nếu muốn pure Vietnamese. Consistency quan trọng hơn — choose one and stick with it.

### Specific UX Issues

#### 30. Color palette inconsistent: purple/green/amber not systematically applied
- **Severity:** medium
- **Section:** Toàn page
- **Detail:** Primary = purple (CEO, nav, retro icon). Secondary = green (health good, status active). Tertiary = amber (health warning, action items). Error = red/pink (health bad). Nhưng agent cards dùng 4 colors: primary, secondary, tertiary, primary (lặp lại). Không có systematic color coding per agent type.
- **Suggestion:** Define color mapping document: Purple = orchestration/CEO, Green = execution/healthy, Amber = warning/in-progress, Blue = review/QA, Red = error/blocked. Apply consistently.

#### 31. Spacing — sections cần thêm breathing room
- **Severity:** low
- **Section:** Between major sections
- **Detail:** `space-y-5` (20px) giữa sections. CEO card → Agents → Projects → Accordions đều same spacing. Visual rhythm monotonous.
- **Suggestion:** Varied spacing: `space-y-6` giữa major sections, `space-y-3` giữa related items. CEO card → thêm `mb-6`. Projects → `mb-6` trước accordions.

#### 32. Sidebar nav active state — chỉ purple text, không đủ strong
- **Severity:** low
- **Section:** Desktop sidebar
- **Detail:** Active nav item: `text-violet-400 font-semibold bg-violet-500/10`. Inactive: `text-slate-500`. Difference mainly in color brightness — not enough visual anchor.
- **Suggestion:** Active item: thêm left border `border-l-2 border-violet-500`. Hoặc background opacity tăng: `bg-violet-500/15`.

#### 33. Loading overlay — no skeleton, just spinner
- **Severity:** low
- **Section:** Page load
- **Detail:** Loading state: spinner + "Đang tải dữ liệu...". No skeleton screens. User sees nothing useful during data fetch.
- **Suggestion:** Add skeleton placeholders matching layout structure. Low priority — page loads fast.

#### 34. Toast notification position — overlaps bottom nav on mobile
- **Severity:** low
- **Section:** Toast component
- **Detail:** Toast fixed `bottom: 80px` — đúng trên desktop, nhưng trên mobile bottom nav chiếm ~64px + safe area. Toast có thể overlap hoặc bị che.
- **Suggestion:** Mobile: `bottom: 100px` hoặc use `env(safe-area-inset-bottom)`.

#### 35. Git commit messages truncated trong project cards
- **Severity:** low
- **Section:** Project health — Git column
- **Detail:** "48645f5 init: cardmasters-ai-support Dis" — truncated mid-word ("Dis..." → "Disconnected"?). Không có cách xem full message.
- **Suggestion:** Truncate at word boundary + ellipsis. Add tooltip/tap-to-expand cho full message.

---

## Priority Matrix

| Priority | Issues |
|----------|--------|
| **Critical (fix ngay)** | #1 CEO prominence, #2 Bottom nav logic, #3 Contrast |
| **High (fix trong sprint này)** | #4 SLA labels, #5 Health score meaningless, #6 Collapsed sections, #7 Empty states, #8 Dead KPIs, #10 Null display bug |
| **Medium (fix soon)** | #9 Velocity label, #11 Section order, #12 Dead nav, #14 KPI weights, #17 Font sizes, #20 Date picker, #21 Tab conflict, #22 Expand affordance, #24 Scroll depth, #25 Mobile grid, #27 Priority legend, #30 Color system |
| **Low (nice-to-have)** | #13 Help link, #15 Agent distinction, #16 Health bar distinction, #18 Language mix, #19 Uppercase, #23 Chevron subtle, #26 Back to top, #28 Agent descriptions, #29 "tệp" word, #31 Spacing, #32 Sidebar active, #33 Skeleton, #34 Toast position, #35 Git truncation |

---

## Quick Wins (1-2 dòng code mỗi cái)

1. **Fix null display**: `esc(p.newestFile && p.newestFile !== 'null' ? p.newestFile : '—')` 
2. **Global min font**: Search-replace `text-[9px]` → `text-[10px]` 
3. **Action Items default open**: Add class `open` to `action-items-body` div
4. **Count badges on accordions**: Add `<span class="text-xs bg-primary/20 text-primary px-2 py-0.5 rounded-full">N</span>` 
5. **Back to top button**: Add floating button with scroll listener 
6. **Toast bottom offset**: `bottom: calc(80px + env(safe-area-inset-bottom))`
7. **Dead nav items**: Add `onclick="showToast('Đang phát triển')"`

---

*Generated by Coach (pm-agent) — Dream Team UX Audit*
