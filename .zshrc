# history
HISTFILE="$HOME/.zsh_history"
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
bindkey '^[[1;3C' forward-word      # alt-right
bindkey '^[[1;3D' backward-word     # alt-left
bindkey '^[[1;9D' beginning-of-line # cmd-left
bindkey '^[[1;9C' end-of-line       # cmd-right

# paths
PLUGIN_DIR="$HOME/.config/plugins"
typeset -U path
path=("$HOME/.local/bin" $path)
path=("$HOME/.cargo/bin" $path)

# zsh
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^G' edit-command-line
autoload -Uz compinit && compinit
# https://github.com/zsh-users/zsh-autosuggestions
source "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey '^[l' autosuggest-accept
# https://github.com/zdharma-continuum/fast-syntax-highlighting
source "$PLUGIN_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# aliases
alias h='cd ~'
alias desk='cd ~/Desktop'
alias g='cd ~/git'
alias ppwd='pwd -P'
alias ..='cd ..'
alias drop='cd ~/Library/CloudStorage/Dropbox/'
alias path='echo -e ${PATH//:/\\n} | sort'
alias clear='printf "\033c"'
alias act='source .venv/bin/activate'

# brew
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# eza https://github.com/eza-community/eza
if command -v eza >/dev/null 2>&1; then
    EZA_OPTIONS='--color=auto --icons=auto --all --reverse'
    EZA_LONG_OPTIONS="$EZA_OPTIONS --long --sort=modified --header --time-style='+%Y %b %e %R' --octal-permissions"
    alias l="eza $EZA_OPTIONS"
    alias ll="eza $EZA_LONG_OPTIONS"
    alias llt="eza $EZA_LONG_OPTIONS --tree --level=2"
    alias lls="eza $EZA_LONG_OPTIONS --total-size"
fi

# fzf https://github.com/junegunn/fzf
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
    export FZF_DEFAULT_OPTS='--no-multi --border=sharp --height 40% --preview-window=hidden'

    # fd
    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type file --type l --follow --hidden --exclude .git'
    fi

    # history
    export FZF_CTRL_R_OPTS='--info=hidden'
    bindkey '^[[A' fzf-history-widget

    # worktrees
    worktree_fzf() {
        local selection
        selection=$(git worktree list 2>/dev/null | awk 'system("test -d \"" $1 "\"")==0' | fzf --reverse) || {
            zle redisplay
            return 0
        }
        zle push-line
        BUFFER="builtin cd -- ${(q)${selection%% *}}"
        zle accept-line
        local ret=$?
        zle reset-prompt
        return $ret
    }
    zle -N worktree_fzf
    bindkey '^[t' worktree_fzf

    # fzf-tab-completion https://github.com/lincheney/fzf-tab-completion
    source "$PLUGIN_DIR/fzf-tab-completion/zsh/fzf-zsh-completion.sh"
fi

# starship https://github.com/starship/starship
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# zoxide https://github.com/ajeetdsouza/zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"

    # zoxide_fzf
    export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --reverse"
    zoxide_fzf() {
        zi
        zle reset-prompt
    }
    zle -N zoxide_fzf
    bindkey '^o' zoxide_fzf
fi

# claude
if command -v claude >/dev/null 2>&1; then
    alias c='claude'
    alias cc='claude agents --cwd .'
    alias ccc='claude --continue'

    # fork any session (all projects) into cwd
    claude_fork_fzf() {
        local id
        id=$(for f in $(ls -t ~/.claude/projects/*/*.jsonl); do
            jq -rn --arg d "$(date -r "$f" '+%m-%d %H:%M')" 'reduce inputs as $e ({};
                if $e.type == "custom-title" then .name = $e.customTitle
                elif $e.type == "ai-title" then .ai = $e.aiTitle
                elif .msg == null and $e.type == "user" and $e.isMeta != true and ($e.message.content | type) == "string"
                then .msg = $e.message.content | .cwd = $e.cwd | .id = $e.sessionId
                else . end)
                | select(.msg)
                | [.id, $d, (.cwd | sub(env.HOME; "~")), (.name // .ai // "" | .[:35]), (.msg | gsub("\\s+"; " ") | .[:120])]
                | @json' "$f" 2>/dev/null
        done | jq -rs 'def pad($n): . + ([range($n - length)] | map(" ") | join(""));
            (transpose | map(map(length) | max)) as $w
            | .[] | "\(.[0])\t\([range(1; 4) as $i | .[$i] | pad($w[$i])] | join("  "))  \(.[4])"' |
            fzf --reverse --delimiter='\t' --with-nth=2 | cut -f1)
        if [[ -z $id ]]; then
            zle redisplay
            return 0
        fi
        zle push-line
        BUFFER="claude --resume $id --fork-session"
        zle accept-line
    }
    zle -N claude_fork_fzf
    bindkey '^[f' claude_fork_fzf
fi

# gh
if command -v gh >/dev/null 2>&1; then
    mkrepo() {
        [[ -n $1 ]] || {
            echo "usage: mkrepo <name>" >&2
            return 1
        }
        local url
        url=$(gh api user/repos -f name="$1" -F private=true \
            -F allow_squash_merge=true -F allow_merge_commit=false -F allow_rebase_merge=false \
            -F delete_branch_on_merge=true \
            -f squash_merge_commit_title=PR_TITLE -f squash_merge_commit_message=PR_BODY \
            --jq .html_url) || return
        git clone "$url" && echo "$url"
    }
fi

if command -v code >/dev/null 2>&1; then
    export EDITOR='code --wait'
    export VISUAL="$EDITOR"
fi
