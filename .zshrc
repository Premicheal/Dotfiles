# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Start tmux automatically
if [ -z "$TMUX" ]; then
    if tmux list-sessions 2>/dev/null | grep -q '(attached)'; then
        tmux
    else
        tmux attach || tmux
    fi
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load completions
autoload -Uz compinit && compinit
# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"
git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

# Arch
# Pacman
alias p='sudo pacman'
alias pss='pacman -Ss'        # Search
alias pi='sudo pacman -S'     # Install
alias pr='sudo pacman -R'     # Remove
alias pu='sudo pacman -Syu'   # Update
alias pc='sudo pacman -Sc'    # Clean cache
alias po='pacman -Qtd'        # List orphans

# AUR 
alias ys='yay -Ss'           # Search AUR
alias yi='yay -S'            # Install from AUR
alias yu='yay -Syu'          # Update including AUR

# System
alias cf='cd ~/.config'
alias sys='sudo systemctl'
alias sysu='sudo systemctl --user'

# Aliases
alias ls='ls --color'
alias c='clear'

export FZF_COMPLETION_TRIGGER='~~'
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export EDITOR='nvim'
export PATH="$PATH":"/var/lib/snapd/snap/bin"
export PATH="$PATH":"$HOME/.local/scripts/"
alias py="python3"
alias python="python3"
alias cat="bat"
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias cd="z"
alias air="~/bin/air"
alias ovpnpath="/Users/prasshan/Library/Application Support/OpenVPN Connect/profiles"
# Alias xsel for pbcopy and pbpaste functionality
if [[ "$(uname)" != "Darwin" ]]; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
fi
alias svim='sudo -E nvim'

# Add in Powerlevel10k
zinit ice as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found


zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
# History
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

tmux-window-name() {
	($TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py &)
}

# if [ -n "$TMUX" ]; then
#     add-zsh-hook chpwd tmux-window-name
# fi
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}
# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(/home/ps/anaconda3/bin/conda shell.zsh hook)"
# Created by `pipx` on 2024-06-15 07:12:58
export PATH="$PATH:/home/ps/.local/bin"

# bun completions
[ -s "/Users/prasshan/.bun/_bun" ] && source "/Users/prasshan/.bun/_bun"

if [ -n "$TMUX" ]; then
    export TERM="tmux-256color"
else
    export TERM="xterm-256color"
fi

# Add this with any of the above options
alias tmux="tmux -2"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=/usr/bin:$PATH
