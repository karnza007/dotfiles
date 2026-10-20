export PATH="$HOME/.local/bin:$PATH"

# Added by Antigravity
export PATH="/Users/karn/.antigravity/antigravity/bin:$PATH"
alias ll="ls -lhG"     # long, human-readable sizes, color
alias la="ls -lahG"    # same, plus hidden files
alias runbot="cd ~/Alpha-One && source .venv/bin/activate && python -m alpha_one.run"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Prompt: user@host in a per-machine colour, so you always know which Mac you're on
# (colour numbers 0-255; see them all: for c in {0..255}; do print -Pn "%F{$c}$c%f "; done)
case $HOST in
  macbookair*) host_color=19 ;;      # dark blue
  macmini*)    host_color=45 ;;      # sky blue
  *)           host_color=yellow ;;
esac
PROMPT="%B%F{$host_color}%n@%m%f%b %1~ %# "
