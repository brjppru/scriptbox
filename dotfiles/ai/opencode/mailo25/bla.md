# Agent Rules

## Remote Target
- Host: `root@192.168.0.25`
- Main repo: `/devel/rss2email`

## SSH Execution
- Use plain SSH only. Do not invent helper commands or rely on custom remote wrappers.
- Treat the remote server as the real workspace.
- Prefer execution styles that minimize quoting depth.

## Command Patterns
- For simple commands, prefer:
  - `ssh root@192.168.0.25 -- <command> <arg1> <arg2>`
- If a command supports an explicit working directory, prefer that over remote `cd`:
  - `git -C /devel/rss2email ...`
  - absolute paths like `/devel/rss2email/...`
- For multiline shell logic, use:
  - `ssh root@192.168.0.25 bash -seu`
  - send the script over stdin
- For multiline Python, use:
  - `ssh root@192.168.0.25 python3 -`
  - send the script over stdin

## Avoid
- Never use nested command strings like `ssh HOST 'python3 -c "..."'` for non-trivial code.
- Never embed large HTML, JSON, regex, Unicode-heavy text, or full file contents inside nested shell quotes.
- Never write complex files with `echo`, `printf`, or chained shell escaping.
- Avoid nested heredocs inside quoted SSH command strings.

## Remote File IO
- For remote reads, prefer small Python snippets over shell text mangling.
- For remote writes, prefer one of:
  1. direct remote editor/file tool
  2. `scp`
  3. `ssh root@192.168.0.25 python3 -` with content sent via stdin
  4. base64 only for payloads

## Base64 Rules
- Use base64 only for payloads: file contents, HTML, regex-heavy text, JSON blobs, Unicode-heavy text, or binary data.
- Do not use base64 for ordinary shell commands.
- Keep control data and payload separate:
  - control = argv, cwd, env
  - payload = stdin or base64

## Quoting Rules
- Prefer stdin over escaping.
- Keep quoting to one layer whenever possible.

## Verification
- After remote writes, always read the target file back.
- Then run the smallest relevant test on the remote host.

## Practical Patterns

### Simple command
```sh
ssh root@192.168.0.25 -- git -C /devel/rss2email status -sb
```

### Multiline shell
```sh
ssh root@192.168.0.25 bash -seu <<'SH'
cd /devel/rss2email
python3 -m unittest discover -s test -p 'test_sanitize_subject.py'
SH
```

### Multiline Python
```sh
ssh root@192.168.0.25 python3 - <<'PY'
from pathlib import Path
print(Path('/devel/rss2email/rss2email/post_process/sanitize_subject.py').read_text(encoding='utf-8'))
PY
```
