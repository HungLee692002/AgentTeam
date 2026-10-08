---
name: plan-feature
description: Giai đoạn 3 - lập plan triển khai từ spec đã duyệt bằng agent planner, có reviewer kiểm tra.
argument-hint: <slug> [ràng buộc kỹ thuật thêm]
---

Giai đoạn PLAN cho tính năng `$0`.

Trước hết nạp skill `agentteam:team-rules` (quy trình, Vòng review, quy tắc chung).

Ghi chú thêm: $ARGUMENTS

1. Kiểm tra `docs/features/$0/spec.md` có `Status: approved`. Nếu không, dừng lại.
2. Giao việc cho subagent `agentteam:planner` với slug `$0` và ghi chú thêm (nếu có).
3. Giao cho subagent `agentteam:reviewer` với loại `plan`. Áp dụng **Vòng review** trong skill `agentteam:team-rules` (sửa bằng `agentteam:planner`).
4. Trình bày: danh sách task (mã, mô tả, phụ thuộc), rủi ro chính, verdict cuối của reviewer.
5. Dừng lại. Nhắc tôi chạy `/agentteam:approve $0 plan` rồi `/agentteam:tests $0`.
