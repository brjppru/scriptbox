# Agent Rules Short

- Remote target: `root@192.168.0.25`, main repo: `/devel/rss2email`.
- Use plain SSH only. Do not invent custom remote helper commands.
- Treat the remote server as the real workspace.
- For simple commands, prefer `ssh root@192.168.0.25 -- <command> <arg1> <arg2>`.
- Prefer explicit remote paths and flags like `git -C /devel/rss2email ...` over remote `cd`.
- For multiline shell, use `ssh root@192.168.0.25 bash -seu` and send the script over stdin.
- For multiline Python, use `ssh root@192.168.0.25 python3 -` and send the script over stdin.
- Never use `ssh HOST 'python3 -c "..."'` for non-trivial code or file content.
- Never embed large HTML, JSON, regex, Unicode-heavy text, or full file contents inside nested shell quotes.
- Never write complex files with `echo`, `printf`, or chained shell escaping.
- For remote file writes, prefer direct file tools, `scp`, or `ssh root@192.168.0.25 python3 -` with content via stdin.
- Use base64 only for payloads like file contents, HTML, regex-heavy text, JSON blobs, Unicode-heavy text, or binary data.
- Do not use base64 for ordinary shell commands.
- Keep control data and payload separate: control = argv/cwd/env, payload = stdin or base64.
- Prefer stdin over escaping and keep quoting to one layer whenever possible.
- After remote writes, always read the target file back and run the smallest relevant remote test.
