# General rules

- Never commit the code yourself without explicit permission

# Git Commit Rules

When creating git commits, always add a Co-authored-by trailer:

Format:
```
<subject line>

<optional body>

Co-authored-by: OpenCode <noreply@opencode.ai>
```

Rules:
- The Co-authored-by line must be the last line of the commit message
- Add a blank line between the commit message body and the trailer
- If there's only a subject line (no body), add a blank line before the trailer
- Never omit the Co-authored-by trailer when creating commits