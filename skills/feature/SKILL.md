---
name: feature
description: Chạy toàn bộ quy trình phát triển một tính năng từ ý tưởng đến pull request, tự chuyển giai đoạn, chỉ dừng khi bị chặn hoặc trước khi push.
argument-hint: <slug> <mô tả ý tưởng>
disable-model-invocation: true
---

Chạy toàn bộ quy trình cho tính năng: $ARGUMENTS

Bạn là điều phối viên. Bạn KHÔNG tự viết research, spec, plan, test hay code — luôn giao cho subagent tương ứng. Việc của bạn: giao việc, chuyển kết quả giữa các agent, áp dụng **Vòng review** trong skill `agentteam:team-rules` (nạp bằng công cụ Skill trước khi bắt đầu), và tự chuyển sang giai đoạn kế tiếp khi reviewer APPROVE (các giai đoạn tự duyệt tài liệu trước theo `agentteam:team-rules`).

Trước khi bắt đầu, kiểm tra `docs/features/<slug>/` xem tính năng đã đi tới giai đoạn nào (dựa vào file nào tồn tại và Status của nó) và tiếp tục từ đó thay vì làm lại.

Các giai đoạn, làm lần lượt:

1. **Research** — làm theo skill `agentteam:research`.
2. **Spec** — làm theo skill `agentteam:spec`. Câu hỏi mở của research: chọn phương án researcher đề xuất và ghi rõ vào spec là giả định; chỉ dừng hỏi nếu câu hỏi chặn hẳn việc viết spec.
3. **Plan** — làm theo skill `agentteam:plan-feature`.
4. **Tests** — làm theo skill `agentteam:tests`.
5. **Implement** — làm theo skill `agentteam:implement` cho mọi task.
6. **Review code** — làm theo skill `agentteam:review-feature`.
   ⛔ Điểm dừng duy nhất theo kế hoạch: hỏi trước khi push và tạo draft PR (quy tắc chung cấm tự push).

Quy tắc:
- Chỉ chuyển giai đoạn khi reviewer APPROVE. Sau 2 vòng sửa vẫn còn Blocking thì dừng và hỏi tôi.
- Nếu bất kỳ agent nào báo bị chặn, dừng và hỏi tôi.
- Sau mỗi giai đoạn, in một dòng trạng thái: `[slug] research ✅ · spec ✅ · plan ⏳ · tests · implement · review`.
