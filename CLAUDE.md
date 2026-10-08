# CLAUDE.md

## Về dự án
<!-- ĐIỀN: mô tả ngắn sản phẩm, người dùng mục tiêu, stack chính -->
- Sản phẩm: TODO
- Stack: TODO (ví dụ: TypeScript, Next.js, PostgreSQL)
- Nhánh chính: `main`

## Lệnh
<!-- ĐIỀN: các agent dùng những lệnh này để kiểm tra công việc -->
- Cài đặt: `TODO` (ví dụ `npm ci`)
- Chạy test toàn bộ: `TODO` (ví dụ `npm test`)
- Chạy một file test: `TODO` (ví dụ `npx vitest run <file>`)
- Lint / type check: `TODO` (ví dụ `npm run lint && npx tsc --noEmit`)
- Chạy app local: `TODO`

## Quy trình phát triển tính năng (agent team)

```
/research → /approve → /spec → /approve → /plan-feature → /approve → /tests → /implement → /review-feature → PR
                                                                (TDD: test viết trước code)
```
Hoặc chạy cả chuỗi với `/feature <slug> <ý tưởng>` (có điểm dừng để duyệt).

| Giai đoạn | Agent | Đầu ra |
|---|---|---|
| Research | `researcher` | `docs/features/<slug>/research.md` |
| Spec | `spec-writer` | `docs/features/<slug>/spec.md` |
| Plan | `planner` | `docs/features/<slug>/plan.md` |
| Tests | `test-engineer` | file test + `docs/features/<slug>/test-plan.md` |
| Implement | `implementer` | code, mỗi task một commit trên `feat/<slug>` |
| Review | `reviewer` | `docs/features/<slug>/reviews/<loại>-<lần>.md` |

Tài liệu bàn giao giữa các agent nằm trong `docs/features/<slug>/`. Template ở `docs/templates/`.

### Vòng review (áp dụng ở mọi giai đoạn)
1. Sau khi agent tạo xong sản phẩm, giao cho `reviewer` kèm `slug` và loại.
2. Lưu nguyên văn kết quả của reviewer vào `docs/features/<slug>/reviews/<loại>-<lần>.md` (reviewer chỉ đọc nên phiên chính ghi file này).
3. Nếu `REQUEST_CHANGES`: gửi các mục Blocking cho đúng agent đã tạo ra sản phẩm để sửa, rồi review lại.
4. Tối đa **2 vòng sửa**. Sau 2 vòng vẫn còn Blocking: dừng, trình bày các điểm bất đồng và để chủ sản phẩm quyết định.
5. Reviewer không bao giờ là agent đã tạo ra sản phẩm đang được review.

### Trạng thái tài liệu
- Dòng đầu mỗi tài liệu là `Status: draft` hoặc `Status: approved`.
- Chỉ chủ sản phẩm duyệt (qua `/approve` hoặc xác nhận rõ ràng trong `/feature`). Giai đoạn sau không chạy nếu tài liệu giai đoạn trước chưa approved.

## Quy tắc cho mọi agent
- Không push lên `main`, không force push, không merge PR. Push nhánh tính năng và tạo PR chỉ khi chủ sản phẩm đồng ý.
- Không sửa hoặc xóa test để làm nó pass.
- Không thêm thư viện mới nếu plan không ghi.
- Không đưa secret, token, API key vào code hoặc tài liệu.
- Commit theo Conventional Commits: `feat(<slug>): ...`, `test(<slug>): ...`, `fix(<slug>): ...`, `docs(<slug>): ...`.
- Khi mơ hồ hoặc bị chặn: dừng và báo, không đoán.

## Quy ước code
<!-- ĐIỀN: quy ước riêng của bạn, ví dụ cấu trúc thư mục, cách xử lý lỗi, cách đặt tên -->
- TODO
