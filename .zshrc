source ~/.rc

autoload -U add-zsh-hook
setopt prompt_subst

# Colors
FMT_RESET=$'%{\033[0m%}'
FMT_BOLD=$'%{\033[2m%}'

FGND_RESET=$'%{\033[39m%}'
FGND_RED=$'%{\033[31m%}'
FGND_LRED=$'%{\033[91m%}'
FGND_LBLUE=$'%{\033[94m%}'

FGND_LORANGE=$'%{\033[38;5;214m%}'
FGND_ORANGE=$'%{\033[38;5;202m%}'

# Prompt
PS1_formatted='[%D{%H:%M}] $FGND_LORANGE%n$FGND_RESET@$FGND_ORANGE%m$FGND_RESET:$FGND_LBLUE%~$FGND_RESET${PROMPT_TERMINATOR-%%} '
PS1=$PS1_formatted

alt_ps1() {
    export PS1="%~%% "
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

# Aliases
if ! [ -x "$(command -v open)" ]; then
    if [ -x "$(command -v xdg-open)" ]; then
        alias open=xdg-open
    fi
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