---
name: spec
description: Giai đoạn 2 - viết spec cho tính năng bằng agent spec-writer, có reviewer kiểm tra. Dùng sau khi research đã duyệt.
argument-hint: <slug> [quyết định cho các câu hỏi mở]
---

Giai đoạn SPEC cho tính năng `$0`.

Toàn bộ tham số (gồm quyết định của tôi): $ARGUMENTS

1. Kiểm tra `docs/features/$0/research.md` tồn tại và có `Status: approved`. Nếu không, dừng và nói tôi cần chạy bước nào.
2. Giao việc cho subagent `spec-writer`: slug `$0`, đường dẫn research, và các quyết định của tôi ở trên.
3. Giao cho subagent `reviewer` với loại `spec`. Áp dụng **Vòng review** trong CLAUDE.md (khi REQUEST_CHANGES thì gửi nhận xét lại cho `spec-writer`).
4. Trình bày: danh sách AC, non-goals, câu hỏi còn mở, verdict cuối của reviewer.
5. Dừng lại. Nhắc tôi đọc `docs/features/$0/spec.md`, rồi chạy `/approve $0 spec` và `/plan-feature $0`.
