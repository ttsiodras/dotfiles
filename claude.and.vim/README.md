# Ctrl+g compose: hooking Claude in

The machinery (scripts + tmux binding) is already here via the dotfiles clone.
Only one thing is per-machine: point Claude's `$VISUAL` at the helper.

Add to `~/.claude/settings.json` (merge into any existing `env`), with your real
home dir — see `.claude-settings.sample.json`:

```json
"env": {
  "VISUAL": "/home/YOURNAME/dotfiles/claude.and.vim/claude-compose-editor"
}
```

Restart Claude (`env` is read only at startup).

Notes:
- Plain-vim machines: edit `claude-compose` line 9 to `editor=(vim)` — the
  committed `--no-servers` is a local wrapper flag and errors on stock vim.
- The tmux binding lives in `../.tmux.conf`; reload with
  `tmux source-file ~/.tmux.conf` if needed.
