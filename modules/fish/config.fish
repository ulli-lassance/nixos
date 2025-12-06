if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Zoxide
zoxide init fish | source
alias cd='z'

# TUI webapp installer
function "webapp"
    bash ~/.config/fish/scripts/webapp $argv
end