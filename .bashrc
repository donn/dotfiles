# vi: ft=bash
source ~/.rc

# Colors
reset_color=$(tput sgr0)

# Prompt
PS1='[\A] \u@\H$:\w\$ '

alt_ps1() {
    export PS1='\w\$ '
    export RPS1=""
}
