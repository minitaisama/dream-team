# Dream Team Playbook

## Mục đích
Playbook chính thức cho Dream Team v2.
Dùng để chuẩn hóa cách Coach, Lebron, Bronny, và Curry phối hợp trong các task development / QA / release.

## Team roles
- **Coach (`pm-agent`)**
  - owns scope, spec, workflow, Definition of Done, release gating
- **Lebron (`be-agent`)**
  - owns backend implementation, code changes, coding execution
- **Bronny (`fe-agent`)**
  - owns frontend implementation, UI/UX, component structure, visual design
- **Curry (`qa-agent`)**
  - owns QA, regression validation, release verification

## Default operating modes
### 1) Solo
Dùng cho task nhỏ, rõ, blast radius thấp.
Coach xử lý trực tiếp hoặc giao 1 micro-task rất hẹp.

### 2) Build
Mode mặc định cho development task bình thường.
Flow:
1. Coach freeze tiny task card
2. Lebron build backend scope
3. Bronny build frontend scope (nếu có)
4. Curry verify changed surface khi cần
5. Coach synthesize và trả kết quả

### 3) Release-critical
Chỉ dùng cho auth / payment / core-flow / blast radius cao.
Curry phải đưa explicit recommendation:
- `ship`
- `ship_with_risk`
- `hold`

## Tiny task card format
Mọi delegated task nên có task card ngắn:
- **Task**
- **Goal**
- **Scope**
- **Non-goals**
- **Acceptance**
- **Risk focus**

## Hard rule: spawn requires task card (except quick-fix)
- **Bất kỳ spawn subagent nào để làm việc thực tế đều phải có task card** (id rõ ràng) để track status + DoD.
- **Ngoại lệ duy nhất:** *quick-fix*.

### Quick-fix definition
Quick-fix chỉ được dùng khi **đồng thời** thỏa ALL điều kiện:
- Patch nhỏ, localized (thường 1 file / vài dòng), dễ rollback
- **Không** đổi behavior sản phẩm / contract / schema, **không** đụng auth/payment/core flows
- Blast radius thấp, rủi ro thấp
- Làm xong trong ~10 phút

Nếu vượt ngưỡng quick-fix (scope phình, chạm behavior, hoặc cần QA), **bắt buộc tạo task card** và chuyển sang flow Build/Release-critical.

## Handoff rules
- Ưu tiên artifact-first handoff
- Không forward full chat history nếu không cần
- Chỉ gửi context tối thiểu để làm đúng việc
- Handoff phải ngắn, gãy gọn, on-point
- Default format cho handoff chỉ nên gồm:
  - scope
  - result / current state
  - risk
  - next step

## Phase 1 runtime guardrails (canon)
Dream Team áp dụng Phase 1 dưới dạng **guardrail vô hình**, không biến thành process nặng.

### 1. Tool-output compaction (P1 — hiệu quả thấy ngay)

Khi tool trả về output quá dài, không feed toàn bộ raw output cho model. Chỉ giữ bản rút gọn.

**Quy tắc cụ thể theo loại tool:**

| Tool | Giữ lại | Bỏ |
|------|---------|-----|
| `exec` (shell) | exit code, command đã chạy, error summary, 50–100 dòng cuối, link/path tới full log | Toàn bộ log dài |
| `diff` / patch | danh sách file đổi, số dòng +/-, vài đoạn patch quan trọng nếu cần | Full patch dài |
| `test` output | số test pass/fail, top failing tests, lỗi đầu tiên đáng chú ý | Full test output |
| JSON dump lớn | summary fields, count, key errors | Raw JSON |

**Tác dụng:** giảm context bị đầy, giảm xác suất timeout, giảm "quên giữa chừng".

### 2. Artifact storage (P2 — đi ngay sau compaction)

Output lớn ghi ra file/artifact riêng, không nằm hết trong session context.

**Path convention:**
```
.openclaw/artifacts/<run-id>/
  ├── exec.log        # full shell log
  ├── test.log        # full test output
  ├── diff.patch      # full diff
  ├── debug.json      # JSON dump lớn
  └── summary.md      # bản tóm tắt cho agent
```

**Nguyên tắc:**
- Giữ bản đầy đủ ở file riêng → vẫn debug được khi cần
- Chỉ đưa bản ngắn gọn vào context agent → model tập trung vào điều quan trọng
- Không bỏ log đi, chỉ chuyển chỗ

### 3. Chunk budget policy (P3 — thêm sau khi P1+P2 ổn)

Đặt giới hạn an toàn cho mỗi đợt làm việc, không để agent chạy một lèo quá dài.

**Budget mặc định:**
- Sau **3–5 tool calls** liên tiếp → tóm tắt lại trạng thái
- Output vượt **ngưỡng chars** → tự rút gọn trước khi feed lại
- Chạy quá **ngưỡng thời gian** → tạm dừng, ghi tình trạng, rồi đi tiếp
- **Budget wide** (không chật): chỉ để chặn runaway, không làm agent khựng

**Checkpoint chỉ khi có giá trị:**
- state đổi rõ ràng
- risk mới xuất hiện
- cần handoff
- sắp chạm budget / timeout

### Context / timeout laws
Nếu long-run bị lỗi, ưu tiên chẩn đoán theo thứ tự:
1. **Context compaction / truncation**
   - Dấu hiệu: agent quên instruction cũ, drift scope, đổi hướng giữa task.
   - Ứng xử chuẩn:
     - summarize state ngắn và ghi ra file / artifact
     - re-read artifact thay vì nhồi lại full history
     - tách nhánh dài sang sub-agent nếu cần
2. **Runtime timeout**
   - Dấu hiệu: run dừng ngang / abort / timeout.
   - Ứng xử chuẩn:
     - chia task thành slices nhỏ hơn
     - persist intermediate state trước mốc dài
     - chỉ tăng timeout khi task thực sự cần long-run

### Activation policy
- **Small / clear task** → Phase 1 gần như invisible.
- **Long / noisy / tool-heavy task** → bật mạnh hơn cho compaction + artifact + budget guard.

### Core laws (tóm tắt)
- **Auto-compact by default** cho output dài / noisy; task nhỏ thì gần như vô hình.
- **Artifact-first, chat-second**: full logs / full diff / full test output để ở artifact; chat chỉ giữ summary ngắn + refs.
- **Wide budgets, rare checkpoints**: budget chỉ để chặn runaway, không làm agent khựng liên tục.
- **Short handoff remains law**: Coach / Lebron / Bronny / Curry chỉ chuyển phần tối thiểu để agent sau làm đúng việc.
- **No extra ritual**: không thêm form, không thêm recap ceremony, không thêm process-theater.

### Anti-patterns
- Không paste full logs vào handoff chat.
- Không sinh báo cáo dài sau mỗi chunk/tool call.
- Không checkpoint/replan quá dày.
- Không để artifact storage biến thành bureaucracy.
- Không dùng Phase 1 để hợp thức hóa over-control hoặc chatter.

### Phase 1 scope (cái gì chưa có)
- Resume full task sau restart kiểu hoàn hảo
- Task state machine hoàn chỉnh
- Checkpoint file chuẩn cho mọi tác vụ
- Auto-recovery thông minh toàn diện

> Phase 1 là: **giảm nghẽn và giảm ngạt** — chưa phải hồi sinh hoàn hảo sau tai nạn.

## CEO execution boundary (Core rule)
- **CEO (MiniSama) KHÔNG làm implementation/detail fixes.**
  - CEO chỉ làm: planning, ưu tiên, dispatch đúng role, ping cross-channel lấy status, unblock, và synthesize kết quả cho Taisama.
- **Mọi “fix nhanh” dù nhỏ** (UI/CSS/infra tweak, task-card cleanup, hotfix) **phải giao cho Coach** (hoặc Coach giao tiếp cho Lebron/Bronny/Curry).
- Ngoại lệ duy nhất: nếu hệ thống đang down hoàn toàn và cần một hành động tối thiểu để phục hồi truy cập (emergency restore) — sau đó lập tức handoff lại cho Coach để làm đúng chuẩn.

## Reporting rules
- Update chỉ khi state đổi:
  - `started`
  - `blocked`
  - `risk found`
  - `finished`
- Báo lại cho Taisama phải ngắn, trực diện, không orchestration fluff

## Development rules
- Không vừa code vừa đổi Definition of Done
- Freeze response contract trước khi giao coding
- Với backend/UI contract changes: cần ít nhất
  - 1 pinned API contract test
  - 1 representative fixture/render check
- Với retrieval/answering work: tạo golden query set trước khi tune

## QA / release rules
- Curry validate theo contract đã freeze, không validate theo target đang trôi
- Khi issue có thể đến từ dữ liệu/corpus/index shape, phải phân loại rõ:
  - parser
  - scorer
  - corpus-quality

## Memory relation
- Rule ổn định, dùng thường xuyên → ở file này
- Retro / lesson learned đang tiến hóa → `memory/process/dream-team.md`
- Heuristic riêng theo role → `memory/process/coach.md`, `memory/process/lebron.md`, `memory/process/bronny.md`, `memory/process/curry.md`

## Notes
Playbook này là bản stable/reference.
Khi Dream Team học thêm từ thực chiến, chỉ promote rule vào đây sau khi đã lặp lại đủ nhiều và chứng minh là hữu ích.
## Adoption note
Dream Team rules were migrated out of `MEMORY.md` so this file is now the canonical stable reference for Dream Team operations.
