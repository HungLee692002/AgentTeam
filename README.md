# agentteam: đội agent cho Claude Code

Plugin gồm 6 agent và 9 lệnh để tự động hóa quy trình phát triển tính năng: **research → spec → plan → tests (TDD) → implement → review → PR**, có điểm duyệt của chủ sản phẩm ở mỗi giai đoạn.

Sửa plugin một lần ở repo này, các dự án đã cài nhận bản mới khi cập nhật.

## Cài đặt (làm ở mỗi máy, mỗi dự án)

Yêu cầu: [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), `git`, `bash` (Git for Windows có sẵn), và [GitHub CLI](https://cli.github.com/) (`gh auth login`) nếu muốn đọc issue/tạo PR. Nếu repo này để private, máy cài phải có quyền truy cập GitHub.

Trong Claude Code:

```text
/plugin marketplace add HungLee692002/AgentTeam
/plugin install agentteam@agentteam
/agentteam:init
```

`/agentteam:init` tạo `CLAUDE.md` mẫu và `docs/features/` trong dự án, rồi giúp điền stack và lệnh test/lint. Đây là phần riêng của từng dự án; agent dùng chúng để tự kiểm tra nên đừng để `TODO`.

### Chọn scope khi cài

`claude plugin install agentteam@agentteam --scope <user|project|local>` (mặc định `user`):

- `user`: mọi dự án trên máy này dùng được.
- `project`: ghi vào `.claude/settings.json` của dự án; ai clone repo cũng được nhắc cài.
- `local`: chỉ bạn, chỉ dự án này (`.claude/settings.local.json`).

Cài đặt không đồng bộ giữa các máy, nên mỗi máy chạy `marketplace add` và `install` một lần. `/agentteam:init` vẫn chạy ở từng dự án.

## Cập nhật

Sau khi sửa plugin, bump `version` trong `.claude-plugin/plugin.json`, commit và push. Ở dự án dùng plugin:

```text
/plugin marketplace update agentteam
/plugin update agentteam@agentteam
```

Không bump `version` thì máy khác có thể không thấy thay đổi.

## Phát triển plugin

```bash
claude --plugin-dir "D:/Personal Project/AgentTeam"   # thử ngay, không cần cài
claude plugin validate .                              # kiểm tra cấu trúc
```
Trong phiên đang chạy, `/reload-plugins` để nạp lại sau khi sửa.

## Cách dùng

```text
/agentteam:research export-csv Cho phép người dùng xuất danh sách giao dịch ra file CSV
/agentteam:approve export-csv research
/agentteam:spec export-csv Chỉ xuất 12 tháng gần nhất; dùng dấu phẩy; UTF-8 có BOM
/agentteam:approve export-csv spec
/agentteam:plan-feature export-csv
/agentteam:approve export-csv plan
/agentteam:tests export-csv          # tạo nhánh feat/export-csv, viết test (đang fail)
/agentteam:implement export-csv      # làm lần lượt T1, T2… mỗi task một commit
/agentteam:review-feature export-csv # review, sửa, hỏi trước khi push + tạo draft PR
```

Hoặc chạy cả chuỗi, dừng ở các điểm duyệt: `/agentteam:feature export-csv <ý tưởng>`. Bị ngắt giữa chừng thì chạy lại cùng lệnh, nó đọc `Status` của các file để làm tiếp.

## Cấu trúc repo

```
.claude-plugin/
  plugin.json          # tên, version
  marketplace.json     # để cài qua /plugin marketplace add
agents/                # 6 agent: researcher, spec-writer, planner, test-engineer, implementer, reviewer
skills/                # lệnh điều phối + team-rules (quy trình, vòng review, quy tắc chung) + init
templates/             # mẫu research/spec/plan/test-plan và CLAUDE.md cho dự án
hooks/hooks.json       # chặn thao tác nguy hiểm
scripts/guard.sh       # logic của hook
```

Trong dự án dùng plugin: `CLAUDE.md` (stack, lệnh, quy ước riêng), `docs/features/<slug>/` (tài liệu từng tính năng), và tùy chọn `docs/templates/<tên>.md` để ghi đè một template.

## Nguyên tắc thiết kế

1. **Bàn giao qua file.** Mỗi agent chạy trong ngữ cảnh riêng, đọc/ghi tài liệu trong `docs/features/<slug>/`; mọi thứ nằm trong git.
2. **Người làm không tự chấm bài.** `reviewer` không có Write/Edit và không bao giờ là agent đã tạo ra sản phẩm. Nó có bộ nhớ riêng (`memory: project`) để nhớ lỗi lặp lại của từng dự án.
3. **Test trước code.** `test-engineer` viết test từ acceptance criteria trước khi `implementer` code; `implementer` bị cấm sửa test cho pass.

## Các lớp an toàn

- **Hook `PreToolUse`** chặn: push lên `main`/`master`, force push, `gh pr merge`, `rm -rf`, đọc `.env*`. (Plugin không phân phối được `permissions.deny`, nên dùng hook thay thế.)
- **Quyền công cụ theo agent**: reviewer chỉ đọc; researcher không cần sửa code.
- **Lệnh có tác dụng phụ chỉ người gọi được**: `tests`, `implement`, `review-feature`, `approve`, `feature`, `init` có `disable-model-invocation: true`.
- **Điểm duyệt**: giai đoạn sau từ chối chạy nếu tài liệu trước chưa `Status: approved`.
- **Giới hạn vòng lặp**: tối đa 2 vòng review–sửa rồi trả quyết định về cho bạn.
- **Không merge**: agent chỉ tạo draft PR.

## Mở rộng

Thêm agent: `agents/<tên>.md`. Thêm lệnh: `skills/<tên>/SKILL.md`. Muốn agent mới tuân theo quy tắc chung, thêm `skills: [team-rules]` vào frontmatter. Quy tắc dùng chung cho cả đội sửa ở `skills/team-rules/SKILL.md`.
