---
name: approve
description: Chủ sản phẩm duyệt một tài liệu (research, spec hoặc plan) của tính năng để mở khóa giai đoạn tiếp theo.
argument-hint: <slug> <research|spec|plan>
disable-model-invocation: true
---

Tôi (chủ sản phẩm) duyệt tài liệu `$1` của tính năng `$0`.

1. Mở `docs/features/$0/$1.md`. Nếu không tồn tại, báo lỗi và dừng.
2. Nếu bản review mới nhất trong `docs/features/$0/reviews/` cho loại này còn mục Blocking chưa xử lý, liệt kê ra và hỏi tôi có chắc muốn duyệt không.
3. Đổi dòng đầu thành `Status: approved` và thêm dòng `Approved: <ngày hôm nay>` ngay dưới.
4. Commit nếu đang trong git repo: `docs(<slug>): approve $1`.
5. Nói cho tôi bước tiếp theo trong quy trình.

Lưu ý: chỉ con người được chạy lệnh này. Agent không bao giờ tự đổi Status thành approved khi chưa có xác nhận rõ ràng của chủ sản phẩm.
