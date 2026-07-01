# dotfiles

My terminal environment, version-controlled so it stays identical across machines.

Configs tracked here:

| Tool        | Repo file            | Symlinked to                  |
| ----------- | -------------------- | ----------------------------- |
| **Zsh**     | `zsh/.zshrc`         | `~/.zshrc`                    |
| **Zsh**     | `zsh/.zprofile`      | `~/.zprofile`                 |
| **Zsh**     | `zsh/.zshenv`        | `~/.zshenv`                   |
| **Vim**     | `vim/.vimrc`         | `~/.vimrc`                    |
| **tmux**    | `tmux/tmux.conf`     | `~/.config/tmux/tmux.conf`    |
| **Ghostty** | `ghostty/config`     | `~/.config/ghostty/config`   |

The real files live in this repo. `install.sh` symlinks them into place, so
editing a file here (or after `git pull`) instantly updates the live config —
there is no copy step to forget.

---

## How it works

`install.sh` creates a symlink for every entry in its `LINKS` table. It is
idempotent (safe to run repeatedly) and, if a *real* file is already sitting at
a target path, it moves that file aside to `<file>.bak-<timestamp>` before
linking. Backups are git-ignored.

---

## First-time setup on a new machine (e.g. the Mac mini)

```bash
git clone <REPO_URL> ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run   # optional: preview what will be linked/backed up
./install.sh             # create the symlinks
exec zsh                 # reload the shell
```

Then finish the tool-specific bootstrap steps below.

### tmux plugins (tpm)

`tmux.conf` uses [tpm](https://github.com/tmux-plugins/tpm) plus
`tmux-resurrect` / `tmux-continuum`. Plugins are **not** committed (they are
git-ignored); install them once:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Start tmux, then press <kbd>prefix</kbd> + <kbd>I</kbd> (capital i) to fetch the
plugins. Saved sessions (`resurrect/`) are machine-local and intentionally not
tracked.

### Ghostty

Ghostty reads `~/.config/ghostty/config` automatically. Reload with
<kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>,</kbd> or by restarting the app.

### Prerequisites

These configs assume the following are installed on the new machine:

- **Homebrew** (`.zprofile` runs `brew shellenv`) — https://brew.sh
- **Rust / cargo** (`.zshenv` sources `~/.cargo/env`) — https://rustup.rs
- **nvm** (loaded in `.zshrc`) — https://github.com/nvm-sh/nvm
- **JetBrains Mono** font (referenced by `ghostty/config`)

If a tool is missing, the shell still starts — the relevant lines just no-op
until you install it.

---

## Porting your current machine INTO the repo (first push)

Already done for the files listed above. To publish the repo for the first
time:

```bash
cd ~/dotfiles
git init
git add .
git commit -m "Initial dotfiles"
git branch -M main
git remote add origin <REPO_URL>   # create an empty repo on GitHub first
git push -u origin main
```

---

## Day-to-day: keeping machines in sync

Because the live files are symlinks into this repo, your normal edits *are*
edits to the repo.

**After changing a config, push it:**

```bash
cd ~/dotfiles
git add -A
git commit -m "Update <tool> config"
git push
```

**On the other machine, pull it:**

```bash
cd ~/dotfiles
git pull
```

Changes take effect immediately (open a new shell / reload the tool). Run
`./install.sh` again only if you *added a brand-new config file* to the repo.

---

## Machine-specific lines to review

Some tracked files contain paths tied to this Mac's setup. They work as-is on a
Mac mini with the same username (`karn`) and Apple-Silicon Homebrew, but review
them if anything differs:

- `zsh/.zprofile` — hard-coded `stm32cube` path under `/Users/karn/...`
- `zsh/.zshrc` — hard-coded Antigravity path under `/Users/karn/...`; nvm block
- `zsh/.zshenv` — sources `~/.cargo/env` (needs Rust installed)

If usernames ever diverge, replace `/Users/karn` with `$HOME` in those files.
