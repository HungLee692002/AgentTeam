---
name: research
description: Giai đoạn 1 - thu thập thông tin cho một tính năng mới bằng agent researcher. Dùng khi bắt đầu một ý tưởng tính năng.
argument-hint: <slug> <mô tả ý tưởng>
---

Giai đoạn RESEARCH cho tính năng `$0`.

Trước hết nạp skill `agentteam:team-rules` (quy trình, Vòng review, quy tắc chung).

Ý tưởng (toàn bộ tham số): $ARGUMENTS

1. Nếu `$0` không phải slug dạng kebab-case (ví dụ `export-csv`), đề xuất một slug và dùng nó.
2. Tạo thư mục `docs/features/<slug>/` nếu chưa có.
3. Giao việc cho subagent `agentteam:researcher` với slug và mô tả ý tưởng.
4. Khi researcher xong, giao cho subagent `agentteam:reviewer` với loại `research`. Áp dụng **Vòng review** trong skill `agentteam:team-rules`.
5. Trình bày cho tôi: tóm tắt, hướng đề xuất, câu hỏi mở, verdict của reviewer.
6. Dừng lại. Nhắc tôi trả lời các câu hỏi mở rồi chạy `/agentteam:approve <slug> research`, sau đó `/agentteam:spec <slug> <các quyết định>`.
