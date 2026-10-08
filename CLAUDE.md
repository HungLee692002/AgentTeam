# CLAUDE.md (repo plugin agentteam)

Repo này là plugin Claude Code kiêm marketplace, không phải ứng dụng. Nội dung cho dự án khác dùng nằm ở `agents/`, `skills/`, `templates/`, `hooks/`, `scripts/`. Xem `README.md`.

- Sửa xong chạy `claude plugin validate .` và thử bằng `claude --plugin-dir .`.
- Quy tắc dùng chung của đội agent chỉ sửa ở `skills/team-rules/SKILL.md`; đừng lặp lại ở agent/skill khác.
- Đổi hành vi thì bump `version` trong `.claude-plugin/plugin.json`.
- Không đưa nội dung riêng của một dự án (stack, lệnh test) vào plugin; chúng thuộc `CLAUDE.md` của dự án đó.
- Không push lên `main`; làm trên nhánh và mở PR.
