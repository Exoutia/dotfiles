# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

ZINIT_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git

if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi


# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"


# my paths
export PATH="/home/bibek/.local/bin:$PATH"
export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"
export NNN_PLUG="f:finder;o:fzopen;p:preview-tui;d:diffs;t:preview-tab;v:imgview;m:nmount"
export NNN_FIFO="/tmp/nnn.fifo"
export NNN_BMS="d:$HOME/Downloads;p:$HOME/Projects;s:$HOME/Pictures/Screenshots;b:$HOME/Downloads/books;m:$HOME/Music;v:$HOME/Videos;"
export EDITOR='nvim'

zinit ice depth=1;

# add in powerlevel10k
# zinit light romkatv/powerlevel10k
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
# zinit light jeffreytse/zsh-vi-mode

# Add in snippets
zinit snippet /usr/share/zsh/plugins/pnpm-shell-completion/pnpm-shell-completion.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
# zinit snippet OMZP::command-not-found
zinit snippet OMZP::zoxide

# load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[x' kill-region

# History
HISTSIZE=5000
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
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls --color $realpath'


# aur helper
aurhelper='yay'

# install packages
function in {
    local pkg="$1"
    if pacman -Si "$pkg" &>/dev/null ; then
        sudo pacman -S "$pkg"
    elif pacman -Qi yay &>/dev/null ; then
        yay -S "$pkg"
    elif pacman -Qi paru &>/dev/null ; then
        paru -S "$pkg"
    fi
}

# Helpful aliases
alias  c='clear' # clear terminal
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lst='eza -1 --icons -sold'
alias lsta='eza -1 --icons -sold -a'
alias la='eza -a'
alias lt='eza --icons=auto --tree' # list folder as tree
# alias in="$aurhelper -S"
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list availabe package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias vc='code' # gui code editor
# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias md='mkdir -p'

# personal function for handling nvimh
alias lnvim="NVIM_APPNAME=LazyNvim nvim"
alias lnvimh="NVIM_APPNAME=LazyNvim neovide"
alias bnvim="NVIM_APPNAME=bnvim nvim"
alias my-nvim="NVIM_APPNAME=myNvim nvim"
alias my-nvimh="NVIM_APPNAME=myNvim neovide"

# for openging my obsdian applocation
alias onvim="cd ~/myNotes && nvim"

# for playing music 
alias mpv_play='mpv ~/Music/music --no-video --shuffle'


alias nnn='nnn -e'

alias nvimh="neovide" # neovide 

if [[ "$TERM"  == "xterm-kitty" ]]; then 
  alias nvim="knvim"
fi

fpath+=~/.zfunc
autoload -Uz compinit && compinit


# Shell integrations
eval "$(fzf --zsh)"
eval "$(starship init zsh)"

# pnpm
export PNPM_HOME="/home/bibek/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
