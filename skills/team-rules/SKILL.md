---
name: team-rules
description: Quy trình, vòng review, trạng thái tài liệu và quy tắc chung của đội agent. Các agent và skill điều phối của plugin agentteam nạp skill này; sửa ở đây là mọi dự án được cập nhật.
---

# Quy tắc chung của đội agent

## Vị trí tài liệu và template
- Tài liệu bàn giao giữa các agent: `docs/features/<slug>/` trong dự án đang làm việc.
- Thư mục template của plugin: `${CLAUDE_PLUGIN_ROOT}/templates/`.
- Dự án có thể ghi đè một template bằng cách đặt file cùng tên vào `docs/templates/` của dự án. Có thì dùng bản của dự án, không thì dùng bản của plugin.
- Lệnh test, lint, tên nhánh chính, quy ước code: đọc từ `CLAUDE.md` của dự án. Nếu còn `TODO`, dừng và báo thay vì đoán.

## Quy trình

```
/agentteam:research → /agentteam:spec → /agentteam:plan-feature → /agentteam:tests → /agentteam:implement → /agentteam:review-feature → PR
                                                                (TDD: test viết trước code)
```
Hoặc chạy cả chuỗi với `/agentteam:feature <slug> <ý tưởng>`.

Không có lệnh duyệt riêng: gọi skill của giai đoạn sau chính là sự đồng ý với tài liệu giai đoạn trước (xem **Trạng thái tài liệu**).

| Giai đoạn | Agent | Đầu ra |
|---|---|---|
| Research | `agentteam:researcher` | `docs/features/<slug>/research.md` |
| Spec | `agentteam:spec-writer` | `docs/features/<slug>/spec.md` |
| Plan | `agentteam:planner` | `docs/features/<slug>/plan.md` |
| Tests | `agentteam:test-engineer` | file test + `docs/features/<slug>/test-plan.md` |
| Implement | `agentteam:implementer` | code, mỗi task một commit trên `feat/<slug>` |
| Review | `agentteam:reviewer` | `docs/features/<slug>/reviews/<loại>-<lần>.md` |

## Vòng review (áp dụng ở mọi giai đoạn)
1. Sau khi agent tạo xong sản phẩm, giao cho `agentteam:reviewer` kèm `slug` và loại.
2. Lưu nguyên văn kết quả của reviewer vào `docs/features/<slug>/reviews/<loại>-<lần>.md` (reviewer chỉ đọc nên phiên chính ghi file này).
3. Nếu `REQUEST_CHANGES`: gửi các mục Blocking cho đúng agent đã tạo ra sản phẩm để sửa, rồi review lại.
4. Tối đa **2 vòng sửa**. Sau 2 vòng vẫn còn Blocking: dừng, trình bày các điểm bất đồng và để chủ sản phẩm quyết định.
5. Reviewer không bao giờ là agent đã tạo ra sản phẩm đang được review.

## Trạng thái tài liệu
- Dòng đầu mỗi tài liệu là `Status: draft` hoặc `Status: approved`.
- Giai đoạn kết thúc ở `Status: draft`. Khi chủ sản phẩm gọi skill của giai đoạn kế tiếp, skill đó tự duyệt tài liệu trước: đổi dòng đầu thành `Status: approved`, thêm dòng `Approved: <ngày>` ngay dưới, rồi mới chạy. Không cần lệnh duyệt riêng.
- Điều kiện để tự duyệt: tài liệu tồn tại và bản review mới nhất cho loại đó không còn mục Blocking. Nếu còn, dừng và nêu các mục đó.
- Agent không tự gọi giai đoạn kế tiếp; chỉ chủ sản phẩm (hoặc `/agentteam:feature`) chuyển giai đoạn.

## Quy tắc cho mọi agent
- Không push lên nhánh chính, không force push, không merge PR. Push nhánh tính năng và tạo PR chỉ khi chủ sản phẩm đồng ý. (Hook của plugin cũng chặn các lệnh này.)
- Không sửa hoặc xóa test để làm nó pass.
- Không thêm thư viện mới nếu plan không ghi.
- Không đưa secret, token, API key vào code hoặc tài liệu.
- Commit theo Conventional Commits: `feat(<slug>): ...`, `test(<slug>): ...`, `fix(<slug>): ...`, `docs(<slug>): ...`.
- Khi mơ hồ hoặc bị chặn: dừng và báo, không đoán.
