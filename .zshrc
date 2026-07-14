# work
# export TMPDIR=$HOME/.local/tmp

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
# https://github.com/rothgar/mastering-zsh/blob/master/docs/config/history.md
setopt EXTENDED_HISTORY     # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY        # Share history between all sessions (incremental append + import).
setopt HIST_IGNORE_ALL_DUPS # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE    # Do not record an event starting with a space.
setopt HIST_VERIFY          # Do not execute immediately upon history expansion.
setopt HIST_NO_STORE        # Don't store history commands

# emacs
bindkey -e
# macos arrow keys https://linux.die.net/man/1/zshzle
bindkey "^[[1;3C" forward-word      # alt-right
bindkey "^[[1;3D" backward-word     # alt-left
bindkey "^[[1;9D" beginning-of-line # cmd-left
bindkey "^[[1;9C" end-of-line       # cmd-right

CONFIG=$HOME/.config
PLUGINS=$CONFIG/plugins

# paths
typeset -U path
path=($HOME/.local/bin $path)
path=($HOME/.cargo/bin $path)
path=($CONFIG/scripts $path)

# brew
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# zsh
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
autoload -Uz compinit && compinit
# https://github.com/zsh-users/zsh-autosuggestions
source $PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^[l' autosuggest-accept
# https://github.com/zdharma-continuum/fast-syntax-highlighting
source $PLUGINS/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# aliases
alias h='cd ~'
alias desk='cd ~/Desktop'
alias g='cd ~/git'
alias ppwd='pwd -P'
alias ..='cd ..'
alias drop='cd ~/Library/CloudStorage/Dropbox/'
alias path='echo -e ${PATH//:/\\n} | sort'
alias env="env | sort | awk -F= '{printf \"%-30s %s\n\", \$1, \$2}'"
alias clear='printf "\033c"'
alias act="source .venv/bin/activate"

# eza https://github.com/eza-community/eza
if command -v eza >/dev/null 2>&1; then
    EZA_OPTIONS="--color=auto --icons=auto --all"
    EZA_LONG_OPTIONS="$EZA_OPTIONS --long --sort=modified --header --time-style='+%Y %b %e %R' --octal-permissions"
    alias l="eza $EZA_OPTIONS"
    alias ll="eza $EZA_LONG_OPTIONS"
    alias llt="eza $EZA_LONG_OPTIONS --tree --level=2"
    alias lls="eza $EZA_LONG_OPTIONS --total-size"
fi

# fzf https://github.com/junegunn/fzf
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
    # https://www.mankier.com/1/fzf#Options-Interface
    export FZF_DEFAULT_OPTS="--no-multi --border=sharp"
    # fd
    if command -v fd >/dev/null 2>&1; then
        # fd https://github.com/sharkdp/fd https://github.com/sharkdp/fd?tab=readme-ov-file#using-fd-with-fzf
        export FZF_DEFAULT_COMMAND="fd --type file --type l --follow --hidden --exclude .git"
    fi
    # history
    export FZF_CTRL_R_OPTS=--info=hidden
    bindkey "^[[A" fzf-history-widget
    # fzf-tab-completion https://github.com/lincheney/fzf-tab-completion
    source $PLUGINS/fzf-tab-completion/zsh/fzf-zsh-completion.sh
fi

# bat https://github.com/sharkdp/bat
if command -v bat >/dev/null 2>&1; then
    alias cat=bat
fi

# starship https://github.com/starship/starship
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# zoxide https://github.com/ajeetdsouza/zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    # https://github.com/ajeetdsouza/zoxide/discussions/1007
    zoxide_fzf() {
        local orig_buffer=$LBUFFER
        local selection
        selection=$(zoxide query --list | fzf --height 40% --reverse) || {
            LBUFFER=$orig_buffer
            zle redisplay
            return 0
        }
        if [[ -n $selection ]]; then
            LBUFFER+=$selection
            zle redisplay
        fi
    }
    zle -N zoxide_fzf
    bindkey '^o' zoxide_fzf
fi

# claude
if command -v claude >/dev/null 2>&1; then
    alias c="claude"
    alias cc="claude agents --cwd ."
    alias ccc="claude --continue"
fi

# herdr
if command -v herdr >/dev/null 2>&1; then
    alias zz=herdr
    alias zd="herdr server stop"
fi

# bob
if command -v bob >/dev/null 2>&1; then
    path+=$HOME/.local/share/bob/nvim-bin
    # export EDITOR=nvim
    # export VISUAL=nvim
    # yadm
    if command -v yadm >/dev/null 2>&1; then
        v() {
            if [[ $PWD == $HOME/.config || $PWD == $HOME/.claude ]]; then
                yadm enter nvim "$@"
            else
                nvim "$@"
            fi
        }
    else
        alias v=nvim
    fi
fi

# lazygit
if command -v lazygit >/dev/null 2>&1; then
    alias gg=lazygit
fi

# vscode
if command -v code >/dev/null 2>&1; then
    export EDITOR="code --wait"
    export VISUAL="code --wait"
fi
