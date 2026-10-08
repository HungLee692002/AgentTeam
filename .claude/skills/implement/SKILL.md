---
name: implement
description: Giai đoạn 5 - triển khai các task trong plan bằng agent implementer, mỗi task một commit.
argument-hint: <slug> [T1 T2 ... | all]
disable-model-invocation: true
---

Giai đoạn IMPLEMENT cho tính năng `$0`.

Tham số: $ARGUMENTS

1. Kiểm tra: `plan.md` có `Status: approved`, `test-plan.md` tồn tại, đang ở nhánh `feat/$0`. Thiếu điều gì thì dừng và nói rõ.
2. Xác định danh sách task: nếu tham số sau slug là mã task (T1, T2...) thì chỉ làm các task đó; nếu trống hoặc `all` thì lấy mọi task chưa đánh dấu `[x]` trong `plan.md`, theo thứ tự phụ thuộc.
3. Với TỪNG task, tuần tự (không song song, vì các task sửa chung codebase):
   a. Giao cho subagent `implementer` đúng một task.
   b. Kiểm tra kết quả trả về: test có pass không, có lệch plan không.
   c. Nếu implementer báo bị chặn (test sai, task mơ hồ, cần thư viện mới), DỪNG toàn bộ và hỏi tôi.
   d. Nếu test fail sau khi implementer báo xong, gửi lại cho implementer tối đa 1 lần; vẫn fail thì dừng và báo.
4. Sau khi xong các task: chạy toàn bộ test suite và lint một lần nữa.
5. Trình bày: bảng task → commit → trạng thái test, các điểm lệch plan.
6. Nhắc tôi chạy `/review-feature $0`.
