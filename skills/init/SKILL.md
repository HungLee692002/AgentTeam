---
name: init
description: Chuẩn bị một dự án để dùng đội agent - tạo CLAUDE.md mẫu (stack, lệnh test/lint) và thư mục docs/features.
disable-model-invocation: true
---

Khởi tạo đội agent cho dự án hiện tại.

1. Nếu `CLAUDE.md` chưa có: chép `${CLAUDE_PLUGIN_ROOT}/templates/CLAUDE.md` vào gốc dự án. Nếu đã có: KHÔNG ghi đè; đọc nó, rồi đề xuất bổ sung các mục còn thiếu (Về dự án, Lệnh, Quy ước code) và chỉ thêm khi tôi đồng ý.
2. Tạo `docs/features/.gitkeep` nếu chưa có.
3. Thử đoán stack và các lệnh (cài đặt, test, lint, chạy local) từ file cấu hình có sẵn (`package.json`, `pyproject.toml`, `Makefile`, `go.mod`...). Đề xuất giá trị điền vào các mục `TODO`, và chỉ điền sau khi tôi xác nhận. Mục nào không đoán được thì giữ `TODO` và nói rõ.
4. Hỏi nhánh chính của dự án (mặc định theo `git symbolic-ref --short refs/remotes/origin/HEAD`) và ghi vào CLAUDE.md.
5. Nhắc tôi: các lệnh test/lint trong CLAUDE.md là thứ agent dựa vào để tự kiểm tra; thiếu là chúng phải đoán.
6. Gợi ý (không tự làm) thêm vào `.claude/settings.json` của dự án các quyền chỉ đọc hay dùng, ví dụ `Bash(git status *)`, `Bash(git diff *)`, `Bash(git log *)`, `Bash(gh issue view *)`, để giảm số lần hỏi quyền.
7. Cuối cùng liệt kê các lệnh có thể dùng, bắt đầu bằng `/agentteam:feature <slug> <ý tưởng>`.
