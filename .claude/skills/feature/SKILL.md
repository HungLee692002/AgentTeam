---
name: feature
description: Chạy toàn bộ quy trình phát triển một tính năng từ ý tưởng đến pull request, có điểm dừng để chủ sản phẩm duyệt sau mỗi giai đoạn.
argument-hint: <slug> <mô tả ý tưởng>
disable-model-invocation: true
---

Chạy toàn bộ quy trình cho tính năng: $ARGUMENTS

Bạn là điều phối viên. Bạn KHÔNG tự viết research, spec, plan, test hay code — luôn giao cho subagent tương ứng. Việc của bạn: giao việc, chuyển kết quả giữa các agent, áp dụng **Vòng review** trong CLAUDE.md, và dừng ở các điểm duyệt.

Trước khi bắt đầu, kiểm tra `docs/features/<slug>/` xem tính năng đã đi tới giai đoạn nào (dựa vào file nào tồn tại và Status của nó) và tiếp tục từ đó thay vì làm lại.

Các giai đoạn, làm lần lượt:

1. **Research** — làm theo skill `research`.
   ⛔ ĐIỂM DUYỆT: trình bày tóm tắt và câu hỏi mở. Chờ tôi trả lời và xác nhận. Khi tôi xác nhận, đổi research.md sang `Status: approved`.
2. **Spec** — làm theo skill `spec`, dùng câu trả lời của tôi làm quyết định.
   ⛔ ĐIỂM DUYỆT: trình bày các AC và non-goals. Chờ tôi xác nhận rồi đổi sang `Status: approved`.
3. **Plan** — làm theo skill `plan-feature`.
   ⛔ ĐIỂM DUYỆT: trình bày danh sách task và rủi ro. Chờ tôi xác nhận rồi đổi sang `Status: approved`.
4. **Tests** — làm theo skill `tests`. Không cần điểm duyệt nếu reviewer APPROVE.
5. **Implement** — làm theo skill `implement` cho mọi task.
6. **Review code** — làm theo skill `review-feature`.
   ⛔ ĐIỂM DUYỆT: hỏi trước khi push và tạo draft PR.

Quy tắc:
- Ở mỗi điểm duyệt, chỉ chuyển giai đoạn khi tôi trả lời rõ ràng là đồng ý. Im lặng hoặc câu hỏi không phải là đồng ý.
- Nếu bất kỳ agent nào báo bị chặn, dừng và hỏi tôi.
- Sau mỗi giai đoạn, in một dòng trạng thái: `[slug] research ✅ · spec ✅ · plan ⏳ · tests · implement · review`.
