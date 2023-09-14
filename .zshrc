source ~/.rc

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
setopt prompt_subst

# Colors
FMT_RESET=$'%{\033[0m%}'
FMT_BOLD=$'%{\033[2m%}'

FGND_RESET=$'%{\033[39m%}'
FGND_RED=$'%{\033[31m%}'
FGND_LRED=$'%{\033[91m%}'
FGND_LGRN=$'%{\033[92m%}'
FGND_LBLUE=$'%{\033[94m%}'

FGND_LORANGE=$'%{\033[38;5;214m%}'
FGND_ORANGE=$'%{\033[38;5;202m%}'

# Prompt
PS1_formatted='[%D{%H:%M}] $FGND_LORANGE%n$FGND_RESET@$FGND_ORANGE%m$FGND_RESET:$FGND_LBLUE%~$FGND_RESET${PROMPT_TERMINATOR-%%} '
PS1=$PS1_formatted

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'   
zstyle ':vcs_info:*' actionformats '%a:%b%u%c'
zstyle ':vcs_info:*' formats '%b%u%c'
RPS1='$FGND_LGRN${vcs_info_msg_0_}$FGND_RESET'

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
