---
name: tests
description: Giai đoạn 4 - thiết kế test case và viết test tự động từ spec (TDD, trước khi implement) bằng agent test-engineer.
argument-hint: <slug>
disable-model-invocation: true
---

Giai đoạn TESTS cho tính năng `$0`.

1. Kiểm tra `docs/features/$0/plan.md` có `Status: approved`. Nếu không, dừng lại.
2. Chuẩn bị nhánh: nếu nhánh `feat/$0` chưa có, tạo từ nhánh chính (xem CLAUDE.md) bằng `git switch -c feat/$0 <nhánh-chính>`; nếu có rồi thì `git switch feat/$0`. Nếu working tree đang có thay đổi chưa commit, dừng và hỏi tôi.
3. Giao việc cho subagent `test-engineer` với slug `$0`.
4. Giao cho subagent `reviewer` với loại `tests`. Áp dụng **Vòng review** trong CLAUDE.md (sửa bằng `test-engineer`).
5. Trình bày: bảng AC → test, số test theo tầng, AC chỉ kiểm tra thủ công, xác nhận test mới đang fail đúng lý do (chưa có code).
6. Nhắc tôi chạy `/implement $0` (toàn bộ) hoặc `/implement $0 T1` (từng task).
