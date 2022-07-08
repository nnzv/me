# Is interactive?
if ( $?prompt ) then
# Enable vi mode
bindkey -v
# Set some aliases
alias g     'git'
alias ns    'doas nvim'
alias pk    'doas pkg_add'
foreach x (vim vi)
    alias $x 'nvim'
end
# Enviroment variables
setenv GOPATH `go env GOPATH`
set path = ( $path "$GOPATH/bin" "/sbin" "/usr/bin" "$HOME/.local/bin" )
set prompt = "% "
setenv G "$HOME/.local/git"
setenv EDITOR `which nvim`
setenv LESSHISTFILE "-"
setenv PYTHONSTARTUP "~/.pythonrc"
setenv CGO_ENABLED "1"
setenv PYTHONDONTWRITEBYTECODE "1"
setenv _JAVA_AWT_WM_NONREPARENTING "1"
