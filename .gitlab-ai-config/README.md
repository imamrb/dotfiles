# ~/.gitlab-ai-config — OpenCode Project Config

This directory contains opencode configuration for the GitLab monorepo.
Files are symlinked into each GDK instance's root so all instances share
the same opencode config and agent instructions.

> ⚠️ Symlinks store absolute paths. If you rename this directory,
> recreate all symlinks pointing to the new path.

## Files

| File              | Purpose                                              |
| ----------------- | ---------------------------------------------------- |
| `opencode.json`   | OpenCode config: MCP servers, models, permissions    |
| `AGENTS.local.md` | Local agent instructions (hard gates, LSP, search)   |
| `duo/`            | Duo CLI flows and prompt history                     |
| `storage.json`    | Runtime state — do NOT symlink (instance-specific)   |

## Current links

```
~/Work/gdk/gitlab/opencode.json        → ~/.gitlab-ai-config/opencode.json
~/Work/gdk/gitlab/AGENTS.local.md      → ~/.gitlab-ai-config/AGENTS.local.md
~/Work/gdk-secondary/gitlab/opencode.json   → ~/.gitlab-ai-config/opencode.json
~/Work/gdk-secondary/gitlab/AGENTS.local.md → ~/.gitlab-ai-config/AGENTS.local.md
```

## Linking to a new GDK instance

```bash
GDK_GITLAB=~/Work/gdk-new/gitlab

ln -sf ~/.gitlab-ai-config/opencode.json   "$GDK_GITLAB/opencode.json"
ln -sf ~/.gitlab-ai-config/AGENTS.local.md "$GDK_GITLAB/AGENTS.local.md"
```
