---
name: review-feature
description: Giai đoạn 6 - review code của tính năng bằng agent reviewer, sửa theo review bằng implementer, rồi chuẩn bị pull request.
argument-hint: <slug>
disable-model-invocation: true
---

Giai đoạn REVIEW CODE cho tính năng `$0`.

1. Đảm bảo đang ở nhánh `feat/$0` và không có thay đổi chưa commit.
2. Giao cho subagent `reviewer` với loại `code`.
3. Áp dụng **Vòng review** trong CLAUDE.md. Khi REQUEST_CHANGES: gửi các mục Blocking cho subagent `implementer` (mỗi lần sửa là một commit `fix(<slug>): ...`), rồi review lại.
4. Gọi subagent `test-engineer` một lần để bổ sung test cho phần code mới chưa được phủ (không sửa test cũ). Chạy lại toàn bộ test.
5. Trình bày: verdict cuối, các mục non-blocking còn lại, kết quả test.
6. Nếu verdict là APPROVE, soạn sẵn tiêu đề và mô tả pull request (tóm tắt, liên kết tới spec/plan, danh sách AC đã đáp ứng, cách kiểm tra thủ công). HỎI tôi trước khi chạy `git push -u origin feat/$0` và `gh pr create --draft`. Không bao giờ merge.
