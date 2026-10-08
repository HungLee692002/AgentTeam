# Agent Team Starter cho Claude Code

Bộ khởi đầu gồm 6 agent và 8 lệnh để tự động hóa quy trình phát triển tính năng cho sản phẩm cá nhân trên GitHub: **thu thập thông tin → spec → plan → test → code → review → PR**.

## Kiến trúc

```
                        Bạn (chủ sản phẩm) — duyệt ở các điểm ⛔
                                      │
                      Phiên Claude Code chính = điều phối viên
                      (chạy các skill /research, /spec, /feature…)
                                      │
   ┌────────────┬────────────┬────────┴───┬──────────────┬─────────────┐
researcher  spec-writer    planner    test-engineer   implementer   reviewer
 research.md   spec.md      plan.md   test + test-plan  code+commit  (chỉ đọc,
                                                                      review tất cả)
```

Ba nguyên tắc thiết kế:

1. **Bàn giao qua file, không qua trí nhớ.** Mỗi agent chạy trong ngữ cảnh riêng và đọc/ghi tài liệu trong `docs/features/<slug>/`. Bạn đọc được, sửa được, và mọi thứ nằm trong git.
2. **Người làm không tự chấm bài.** `reviewer` chỉ có quyền đọc và không phải agent đã tạo ra sản phẩm. Nó có bộ nhớ riêng (`memory: project`) để ghi nhớ các lỗi lặp lại trong dự án của bạn.
3. **Test viết trước code (TDD).** `test-engineer` viết test từ acceptance criteria trong spec, trước khi `implementer` code. Như vậy test phản ánh yêu cầu thật chứ không phản ánh code. `implementer` bị cấm sửa test để cho pass.

## Cài đặt

Yêu cầu: [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), `git`, và [GitHub CLI](https://cli.github.com/) (`gh auth login`) nếu muốn agent đọc issue và tạo PR.

1. Chép vào gốc repo của bạn:
   ```bash
   cp -r agent-team-starter/.claude  <repo>/
   cp -r agent-team-starter/docs     <repo>/
   cp    agent-team-starter/CLAUDE.md <repo>/   # nếu đã có CLAUDE.md, gộp nội dung vào
   ```
2. **Mở `CLAUDE.md` và điền các mục TODO**, quan trọng nhất là mục **Lệnh** (test, lint). Agent dùng các lệnh này để tự kiểm tra; thiếu là chúng phải đoán.
3. Nếu nhánh chính không phải `main`, sửa trong `CLAUDE.md` và `.claude/settings.json`.
4. Commit thư mục `.claude/` và `docs/` vào repo.
5. Mở Claude Code trong repo, gõ `/` để thấy các lệnh mới.

## Cách dùng

### Chạy từng bước (khuyên dùng khi mới bắt đầu)

```text
/research export-csv Cho phép người dùng xuất danh sách giao dịch ra file CSV
   → đọc docs/features/export-csv/research.md, trả lời câu hỏi mở
/approve export-csv research
/spec export-csv Chỉ xuất 12 tháng gần nhất; dùng dấu phẩy; UTF-8 có BOM
   → đọc spec.md, kiểm tra các AC
/approve export-csv spec
/plan-feature export-csv
/approve export-csv plan
/tests export-csv          → tạo nhánh feat/export-csv, viết test (đang fail)
/implement export-csv      → làm lần lượt T1, T2… mỗi task một commit
/review-feature export-csv → review, sửa, hỏi bạn trước khi push + tạo draft PR
```

### Chạy cả chuỗi

```text
/feature export-csv Cho phép người dùng xuất danh sách giao dịch ra file CSV
```
Claude sẽ đi qua toàn bộ giai đoạn và dừng ở các điểm ⛔ để chờ bạn duyệt. Nếu bị ngắt giữa chừng, chạy lại cùng lệnh: nó đọc Status của các file để tiếp tục từ chỗ dừng.

### Gọi agent trực tiếp

Ngoài các lệnh, bạn có thể gọi agent bằng `@`, ví dụ `@"reviewer (agent)" review code của nhánh hiện tại`.

## Cấu trúc thư mục

```
CLAUDE.md                    # quy tắc chung, lệnh, quy trình (mọi agent đều đọc)
.claude/
  settings.json              # quyền: chặn push main, force push, merge PR, rm -rf, đọc .env
  agents/                    # 6 agent: mỗi file = vai trò + công cụ được phép + quy trình
  skills/                    # 8 lệnh điều phối: research, spec, plan-feature, tests,
                             #   implement, review-feature, approve, feature
docs/
  templates/                 # mẫu research / spec / plan / test-plan
  features/<slug>/           # tài liệu của từng tính năng (do agent tạo)
    reviews/                 # lịch sử review
```

## Các lớp an toàn

- **Quyền công cụ theo agent**: reviewer không có Write/Edit; researcher không cần sửa code.
- **Chặn bằng settings**: push lên main, force push, `gh pr merge`, `rm -rf`, đọc `.env` đều bị từ chối.
- **Lệnh có tác dụng phụ chỉ người gọi được**: `/tests`, `/implement`, `/review-feature`, `/approve`, `/feature` có `disable-model-invocation: true`, Claude không tự chạy chúng.
- **Điểm duyệt**: giai đoạn sau từ chối chạy nếu tài liệu trước chưa `Status: approved`.
- **Giới hạn vòng lặp**: tối đa 2 vòng review–sửa, sau đó trả quyết định về cho bạn.
- **Không merge**: agent chỉ tạo draft PR, merge luôn là việc của bạn.

## Mở rộng

**Thêm agent**: tạo `.claude/agents/<tên>.md` với frontmatter `name`, `description`, `tools`. Ý tưởng:
- `ui-designer`: tạo wireframe/HTML mockup từ spec trước khi plan
- `security-auditor`: chạy riêng cho tính năng đụng tới xác thực, thanh toán
- `docs-writer`: cập nhật README/CHANGELOG sau khi merge
- `debugger`: điều tra bug từ issue, viết test tái hiện trước khi sửa

**Thêm skill kiến thức** (Claude tự nạp khi liên quan): ví dụ `.claude/skills/api-conventions/SKILL.md` chứa quy ước API của bạn, rồi khai báo `skills: [api-conventions]` trong frontmatter của `implementer` và `reviewer` để nạp sẵn.

**Thêm flow mới**: chép một skill có sẵn làm mẫu. Ví dụ `/bugfix <issue>`: `debugger` tái hiện → `test-engineer` viết test fail → `implementer` sửa → `reviewer`.

**Hook tự động**: thêm vào `.claude/settings.json` để chạy lint sau mỗi lần sửa file, ví dụ:
```json
"hooks": {
  "PostToolUse": [
    { "matcher": "Edit|Write", "hooks": [ { "type": "command", "command": "npm run lint --silent" } ] }
  ]
}
```

**Tiết kiệm chi phí**: tất cả agent đang dùng `model: inherit`. Có thể đặt `model: sonnet` hoặc `model: haiku` cho `researcher` và `test-engineer`, giữ model mạnh cho `planner` và `reviewer`.

**Chạy trên GitHub**: khi quy trình local ổn định, có thể dùng Claude Code trong GitHub Actions để tự review mọi PR. Các agent và skill trong `.claude/` của repo sẽ được dùng lại.

## Đo hiệu quả

Sau 3–5 tính năng, xem lại:
- Bao nhiêu % review vòng đầu là APPROVE? (thấp → prompt của agent tạo sản phẩm cần chặt hơn)
- Lỗi nào reviewer bắt lặp lại? (xem `.claude/agent-memory/reviewer/`) → đưa thành quy tắc trong `CLAUDE.md`
- Bạn phải sửa tay những gì sau khi agent xong? → đó là chỗ cần cải thiện prompt tiếp theo

Mỗi khi sửa prompt của agent, hãy chạy lại trên một tính năng cũ để so sánh.
