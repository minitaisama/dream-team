# QA Batch 2 — fixes #6-10 + recheck #1-5

Live site checked with cache-bust:
- Desktop: `https://dreamteam-by-taisama.vercel.app/?v=2`
- Mobile: `375x812` + `https://dreamteam-by-taisama.vercel.app/?v=2`

## Result summary

1. ✅ **PASS — CEO Card glow shadow visible**
   - Computed style on CEO card includes: `rgba(109, 59, 215, 0.15) 0px 0px 40px 0px`
   - Evidence: glow is present on desktop CEO card around `👑 CEO / Mini Taisama`

2. ✅ **PASS — Bottom nav sync works**
   - Click header tab **"Hôm nay"** → bottom nav **"Tổng quan"** is active (purple active state)
   - Click bottom nav **"Tuần"** → header tab **"Tuần"** becomes active with background `rgba(208, 188, 255, 0.2)`

3. ❌ **FAIL — Font sizes still go below 10px**
   - Found computed `font-size: 8px` on visible text:
     - `process`
     - `technical`
     - `03-23`
   - KPI labels are mostly OK:
     - `Hoàn thành`, `Bị chặn`, `Action mở`, `Agent` = `12px`
     - `Tokens` found at `12px` and also one instance at `11px`
   - Main failure reason: still has visible `8px` text

4. ✅ **PASS — SLA renamed**
   - Section title shows **`⏱ TỐC ĐỘ XỬ LÝ`**
   - `Resolution SLA` not found anywhere on the page

5. ✅ **PASS — Health Score N/A**
   - Health scores display **`—`** instead of `50`
   - CEO card shows `—` with `N/A`
   - Tooltip/help text exists via accessibility description:
     - `Điểm sức khỏe = tổng hợp hiệu suất, chất lượng, phản hồi. 70+ Tốt, 40-69 Bình thường, <40 Cần chú ý`

6. ✅ **PASS — Collapsible sections**
   - **Action Items** is default **expanded**
   - Computed state on collapsible body: `maxHeight: 2000px`
   - Other sections like Daily Retro / Feedback are collapsed with `maxHeight: 0px`
   - Count badge/header visible as **`✅ Action Items 5`** with sublabel **`5 items mở`**

7. ✅ **PASS — Empty states have icon + title + subtitle**
   - Feedback section empty state shows:
     - icon: `inbox`
     - title: `Chưa có feedback`
     - subtitle: `Feedback sẽ xuất hiện khi agents giao tiếp trong retro.`
   - SLA/processing section also shows 2-line empty messaging, not a single bare line

8. ❌ **FAIL — KPI zeros still show `0` in multiple places**
   - Top summary partly fixed:
     - `Hoàn thành` = `—`
     - `Bị chặn` = `—`
     - `Tokens` = `—`
   - But many KPI cards still show literal `0`, for example:
     - `Tasks handled` = `0`
     - `Tasks shipped` = `0`
     - `Lessons` = `0`
     - `Tasks reviewed` = `0`
     - `Issues found` = `0`
     - `Components` = `0`
   - If expected rule is global zero-to-dash for KPI values, fix is incomplete

9. ❌ **FAIL — Improvement rename not found**
   - `📊 Tiến trình bài học` not found on live page
   - `Improvement` also not found
   - No visible replacement chart/section with bar value labels found on checked live page

10. ✅ **PASS — pkm-auction null fixed**
   - `pkm-auction` section shows **`Chưa có file`**
   - Raw `null` text not found on page

## Desktop/mobile note
- Rechecked on mobile viewport (`375x812`) with cache-bust `?v=2`
- Confirmed on mobile:
  - bottom nav visible
  - `✅ Action Items 5` present
  - feedback empty state present
  - `⏱ TỐC ĐỘ XỬ LÝ` present
  - `Chưa có file` present
  - `Tiến trình bài học` still missing

## Final verdict
- **PASS:** 1, 2, 4, 5, 6, 7, 10
- **FAIL:** 3, 8, 9
