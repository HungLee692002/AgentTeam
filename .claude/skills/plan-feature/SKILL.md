---
name: plan-feature
description: Giai đoạn 3 - lập plan triển khai từ spec đã duyệt bằng agent planner, có reviewer kiểm tra.
argument-hint: <slug> [ràng buộc kỹ thuật thêm]
---

Giai đoạn PLAN cho tính năng `$0`.

Ghi chú thêm: $ARGUMENTS

1. Kiểm tra `docs/features/$0/spec.md` có `Status: approved`. Nếu không, dừng lại.
2. Giao việc cho subagent `planner` với slug `$0` và ghi chú thêm (nếu có).
3. Giao cho subagent `reviewer` với loại `plan`. Áp dụng **Vòng review** trong CLAUDE.md (sửa bằng `planner`).
4. Trình bày: danh sách task (mã, mô tả, phụ thuộc), rủi ro chính, verdict cuối của reviewer.
5. Dừng lại. Nhắc tôi chạy `/approve $0 plan` rồi `/tests $0`.
