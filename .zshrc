source ~/.rc

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -U compinit && compinit
autoload -U colors && colors
setopt autocd
setopt prompt_subst
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST

export SAVEHIST=1000
export HISTSIZE=999

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# Colors
FGND_LBLUE=$'%{\033[94m%}'
FGND_LORANGE=$'%{\033[38;5;214m%}'
FGND_ORANGE=$'%{\033[38;5;202m%}'

# Prompt
PS1_formatted='[%D{%H:%M}] $FGND_LORANGE%n%{$reset_color%}@$FGND_ORANGE%m%{$reset_color%}:$FGND_LBLUE%~%{$reset_color%}${PROMPT_TERMINATOR-%%} '
PS1=$PS1_formatted

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'   
zstyle ':vcs_info:*' actionformats '%a:%b%u%c'
zstyle ':vcs_info:*' formats '%b%u%c'
RPS1='${EXIT_INFO}%{$fg[green]%}${vcs_info_msg_0_}%{$reset_color%}'

exit_info() {
    last_exit=$?
    if [ "$last_exit" != "0" ]; then
        MESSAGE=$last_exit
        if (( $last_exit > 128 )); then
            sig=$(($last_exit - 128))
            MESSAGE="SIG$(kill -l $sig)"
        fi
        export EXIT_INFO="%{$fg[red]%}%B($MESSAGE)%b ❌%{$reset_color%}"
    else
        export EXIT_INFO="⭕"
    fi
    if [ "${vcs_info_msg_0_}" != "" ]; then
        export EXIT_INFO="$EXIT_INFO | "
    fi
}

precmd_in_nix_shell() {
    if [ "$IN_NIX_SHELL" = "impure" ]; then
        export PROMPT_TERMINATOR="δ"
    elif [ "$IN_NIX_SHELL" = "pure" ]; then
        export PROMPT_TERMINATOR="λ"
    else
        unset PROMPT_TERMINATOR
    fi
}
add-zsh-hook precmd precmd_in_nix_shell
add-zsh-hook precmd vcs_info
add-zsh-hook precmd exit_info

alt_ps1() {
    export PS1="%~%% "
}

# Aliases
if command -v thefuck &> /dev/null; then
    eval $(thefuck --alias)
fi

# Shortcuts
cremake () {
    if ! [ -f "$PWD/CMakeCache.txt" ]; then
        if [ $(ls -A "$PWD" | wc -l) -ne 0 ]; then
            echo "CMakeCache not detected in a non-empty directory. Refusing to nuke working directory." > /dev/stderr
            return -1
        fi
    fi
    
    if [ -d "$PWD/.git" ]; then
        echo "Git directory detected. Refusing to nuke working directory." > /dev/stderr
        return -1
    fi

    rm -rf EmptyDirectory `find . -mindepth 1`
    cmake $@
}

# Google Cloud SDK
if [ -f '$HOME/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/donn/bin/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '$HOME/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/donn/bin/google-cloud-sdk/completion.zsh.inc'; fi
