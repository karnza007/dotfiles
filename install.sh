#!/usr/bin/env bash
#
# install.sh — symlink the dotfiles in this repo into their real locations.
#
# Safe to re-run (idempotent). If a real (non-symlink) file already exists at a
# target, it is moved aside to <file>.bak-<timestamp> before the symlink is made.
#
# Usage:
#   ./install.sh          # create the symlinks
#   ./install.sh --dry-run  # print what would happen, change nothing

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

# Map: "<path relative to repo>" -> "<absolute target path>"
# Add a new line here whenever you add a new config file to the repo.
declare -a LINKS=(
  "zsh/.zshrc|$HOME/.zshrc"
  "zsh/.zprofile|$HOME/.zprofile"
  "zsh/.zshenv|$HOME/.zshenv"
  "vim/.vimrc|$HOME/.vimrc"
  "tmux/tmux.conf|$HOME/.config/tmux/tmux.conf"
  "ghostty/config|$HOME/.config/ghostty/config"
)

link() {
  local src="$REPO/$1" dst="$2"

  if [[ ! -e "$src" ]]; then
    echo "SKIP  $1 (missing in repo)"; return
  fi

  # Already the correct symlink? Nothing to do.
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "OK    $dst"; return
  fi

  if [[ $DRY_RUN -eq 1 ]]; then
    echo "PLAN  $dst -> $src"; return
  fi

  mkdir -p "$(dirname "$dst")"

  # Back up a real file/dir that is in the way (but not an old symlink).
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local bak="$dst.bak-$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$bak"
    echo "BAK   $dst -> $bak"
  fi

  ln -sfn "$src" "$dst"
  echo "LINK  $dst -> $src"
}

echo "Repo: $REPO"
[[ $DRY_RUN -eq 1 ]] && echo "(dry run — no changes will be made)"
for pair in "${LINKS[@]}"; do
  link "${pair%%|*}" "${pair##*|}"
done
echo "Done."
