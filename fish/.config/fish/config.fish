if status is-interactive
    # TODO?
end

### Alias + abbreviations ###
alias ls="eza --color=auto"
alias cat="bat"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"

abbr --add l        ls -lhAF
abbr --add la       ls -hA
abbr --add ll       ls -lh

# Sane defaults
abbr --add cp       cp -vi
abbr --add mv       mv -vi
abbr --add rm       rm -vi
abbr --add ln       ln -vi

abbr --add mkdir    mkdir -vp
abbr --add df       df -H
abbr --add rmdir    rmdir -v --ignore-fail-on-non-empty

abbr --add h        history
abbr --add f        fd
abbr --add r        ranger
abbr --add rs       rsync -avzP
abbr --add imgcat   kitty +kitten icat

# Typos
abbr --add mdkir    mkdir

# direnv hook
direnv hook fish | source