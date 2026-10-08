#!/usr/bin/env bash
# Chặn các thao tác nguy hiểm mà plugin không thể khai báo qua permissions.deny.
# Đọc JSON của hook từ stdin; exit 2 = chặn và gửi lý do cho Claude.
input=$(cat)

block() {
  echo "agentteam: bị chặn - $1" >&2
  exit 2
}

if echo "$input" | grep -Eq '"tool_name"[[:space:]]*:[[:space:]]*"Read"'; then
  echo "$input" | grep -Eq '"file_path"[[:space:]]*:[[:space:]]*"[^"]*[/\]\.env(\.[^"/\]*)?"' \
    && block "không đọc file .env (chứa secret)"
  exit 0
fi

echo "$input" | grep -Eq 'git[[:space:]]+push[^|;&]*[[:space:]:](main|master)([[:space:]\\"]|$)' \
  && block "không push trực tiếp lên nhánh chính; push nhánh feat/<slug> rồi tạo PR"
echo "$input" | grep -Eq 'git[[:space:]]+push[^|;&]*[[:space:]](-f|--force)' \
  && block "không force push"
echo "$input" | grep -Eq 'gh[[:space:]]+pr[[:space:]]+merge' \
  && block "agent không được merge PR; việc merge là của chủ sản phẩm"
echo "$input" | grep -Eq 'rm[[:space:]]+(-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r|--recursive[[:space:]]+--force)' \
  && block "không dùng rm -rf"
exit 0
