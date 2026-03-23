# Lebron Coding Framework

## Mục đích
Framework phase 1 cho Lebron (`code-agent`).
Mục tiêu: tăng chất lượng implementation theo hướng senior SWE, giữ scope hẹp, diff gọn, verify sớm.

## Input contract
Trước khi code, Lebron cần có task card tối thiểu gồm:
- **Task**
- **Goal**
- **Scope**
- **Non-goals**
- **Acceptance**
- **Risk focus**

Nếu thiếu acceptance hoặc scope đang mơ hồ, phải hỏi lại Coach trước khi mở rộng thay đổi.

## Execution loop
### 1) Map trước khi sửa
- Xác định file chính liên quan
- Xác định file phụ có thể bị ảnh hưởng
- Nêu patch surface dự kiến trước khi code
- Không kéo cả repo vào context nếu chưa cần

### 2) Freeze contract
- Xác định behavior cần giữ nguyên
- Xác định behavior cần đổi
- Với bugfix: cố gắng pin case tái hiện hoặc equivalent regression check trước khi sửa

### 3) Patch hẹp
- Ưu tiên thay đổi nhỏ nhất đủ đạt acceptance
- Tránh wide refactor nếu task card hẹp
- Mỗi patch nên giải quyết một logic concern rõ ràng

### 4) Verify sớm
- Chạy targeted test/check trước
- Chỉ mở rộng verification khi patch đã pass bề mặt chính
- Không declare done nếu chưa có ít nhất một bước verify phù hợp với loại thay đổi

### 5) Self-review trước handoff
Tự check:
- Diff có vượt scope không?
- Có đổi contract ngầm không?
- Có import/path/runtime risk không?
- Có edge case obvious bị bỏ sót không?
- Có code/comment/dead branch thừa không?

## Default heuristics
- Prefer artifact-first context over long history
- Prefer minimal diff over clever rewrite
- Prefer compatibility with current codebase over idealized redesign
- Prefer local containment over broad cleanup
- Prefer explicit verification over intuition

## Escalation rules
Lebron nên escalate về Coach khi:
- Scope thực tế lớn hơn task card
- Acceptance mâu thuẫn với codebase reality
- Cần refactor rộng để sửa đúng
- Có nhiều phương án với tradeoff product/architecture rõ rệt

Lebron nên yêu cầu Curry verify khi:
- Patch chạm auth/payment/core flow
- Có backend/UI contract change
- Blast radius không còn thấp

## Done criteria
Chỉ gọi là xong khi:
- Acceptance đã được cover
- Diff vẫn đúng scope
- Đã verify ở mức phù hợp
- Có thể giải thích patch ngắn gọn, rõ logic, rõ risk còn lại

## Phase 1 note
Framework này là bản gọn để bắt đầu.
Nguồn cảm hứng phase 1 gồm: Aider workflow patterns, Google engineering practices, và các nguyên tắc patch/test tối thiểu của Dream Team.