ZSH=$HOME/.oh-my-zsh
plugins=(history-substring-search)
source $ZSH/oh-my-zsh.sh

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd extendedglob
setopt EXTENDED_HISTORY		# puts timestamps in the history


BLACK="%{"$'\033[01;30m'"%}"
GREEN="%{"$'\033[01;32m'"%}"
RED="%{"$'\033[01;31m'"%}"
YELLOW="%{"$'\033[01;33m'"%}"
BLUE="%{"$'\033[01;34m'"%}"
BOLD="%{"$'\033[01;39m'"%}"
NORM="%{"$'\033[00m'"%}"

autoload -Uz vcs_info

# prompt (if running screen, show window #)
if [ x$WINDOW != x ]; then
    export PS1="$WINDOW:%~%# "
else
      export PS1="
<${YELLOW}%~${NORM}>
${RED}%n${YELLOW}@${BLUE}%U%m%u$%(!.#.$) "
    #export PS1="[${RED}%n${YELLOW}@${BLUE}%U%m%u$:${GREEN}%2c${NORM}]%(!.#.$) "
    #right prompt - time/date stamp
    #export RPS1="${GREEN}(%D{%m-%d %H:%M})${NORM}"
    # this right prompt is for any kind of repository info - svn, git, mercurial ,etc. courtesy of vcs_info
    export RPS1="${YELLOW}%1v${NORM}"
fi

# format titles for screen and rxvt
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\"      # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2 | $a:$3\a" # plain xterm title
    ;;
  esac
}

# precmd is called just before the prompt is printed
function precmd() {
  title "zsh" "$USER@%m" "%55<...<%~"
  psvar=()
  vcs_info
  [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"
}

# preexec is called just before any command line is executed
function preexec() {
  title "$1" "$USER@%m" "%35<...<%~"
}

# this is ubuntu specific - in case you execute a command
# that is not installed, zsh automatically calls this handler
# so that you get a nice recommendation message (similar to bash)
function command_not_found_handler() {
     /usr/bin/python /usr/lib/command-not-found -- $1
}

# vi editing
# this prevents me from deleting a word using ESC-Backspace
#bindkey -v

# colorful listings
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -U compinit
compinit

# aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias j=jobs
if ls -F --color=auto >&/dev/null; then
  alias ls="ls --color=auto -F"
else
  alias ls="ls -F"
fi
alias ll="ls -l"
alias ..='cd ..'
alias .='pwd'
alias grep='grep -E --color=always'
alias find='noglob find'
alias vim='gvim'
alias ssh-linode='ssh -l clearsenses li44-22.members.linode.com'
alias ssh-nsmg-core='ssh clearsenses@64.85.169.69'
alias ssh-clearsenses-core='ssh clearsenses@64.85.167.191'
alias ssh-nsmg='ssh -l nsmg li50-150.members.linode.com'
alias ssh-darthvader='ssh -l clearsenses 192.168.1.12'
alias ssh-exotic='ssh -l sss 96.31.86.172'
alias ssh-harper='ssh -l sandeep 173.255.226.191'
alias ssh-metric='ssh dbadmin@74.86.128.24'
alias ssh-metric-test='ssh sss@74.91.27.34'
alias ssh-clearsenses-hive='ssh sss@66.232.106.200'
export SBCL_HOME=/home/user/research/lisp/sbcl-1.0.29/release/lib/sbcl/
export SCALA_HOME=/usr
# for webcam
export XLIB_SKIP_ARGB_VISUALS=1 
#path=( /home/user/research/jdk1.6.0_24/bin /home/user/research/jruby-1.6.2/bin /home/user/bin/Sublime\ Text\ 2 $path)
#path=(/home/user/clearsenses/ruby-enterprise-1.8.7-20090928/release/bin /home/user/research/jruby-1.6.0.RC3/bin $path)
export PATH
alias sbcl='/home/user/research/lisp/sbcl-1.0.29/release/bin/sbcl'
export SBCL_HOME=/home/user/research/lisp/sbcl-1.0.29/release/lib/sbcl/
alias sbcl='/home/user/research/lisp/sbcl-1.0.29/release/bin/sbcl'
alias sg='cd /home/user/clearsenses/jambool/REPO/socialgold'
alias jm='cd /home/user/clearsenses/jambool/REPO/jambool'
alias api='cd /home/user/clearsenses/jambool/REPO/api'
#copy with progress bar
alias cp='rsync -aP'
alias netstat='netstat -ap'
#alias drush='/home/user/clearsenses/mojostation/drush/drush'
alias drush='/usr/sbin/php-fpm/bin/php /home/user/clearsenses/mojostation/drush/drush.php'
#alias sbt='java -Xmx1500M -jar /home/user/Code/sbt/bin/sbt-launch.jar $@'
alias sbt="java -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M -jar `dirname $0`/sbt-launch.jar "$@""
#alias ruby='/home/user/research/rubinius-1.1.0/release/rubinius/1.1/bin/rbx'
#alias ruby='java -server -jar /home/user/research/jruby-complete-1.6.0.RC3.jar'
#alias ruby='jruby'
#alias ruby='/home/user/research/ruby-enterprise-1.8.7-2011.03/release/bin/ruby'
#alias gem='/home/user/research/rubinius-1.1.0/release/rubinius/1.1/bin/rbx -S gem'
#alias gem='jruby -S gem'
#alias gem='/home/user/research/ruby-enterprise-1.8.7-2011.03/release/bin/ruby /home/user/research/ruby-enterprise-1.8.7-2011.03/release/bin/gem'
#alias rake='jruby -S rake'
#alias rake='/home/user/research/ruby-enterprise-1.8.7-2011.03/release/bin/ruby /home/user/research/ruby-enterprise-1.8.7-2011.03/release/bin/rake'


alias curlget='noglob curl -fSkLC  - -OLRJ -w "URL: %{url_effective} AVG-Speed:%{speed_download}"'
alias netstat-listen='lsof -iTCP -sTCP:LISTEN'
alias st="/home/user/tools/Sublime\ Text\ 2/sublime_text"

#ZSH hacks for special characters 
alias rake='noglob rake'
alias bundle='noglob bundle'
alias curl='noglob'

#exports
#path=(/home/user/clearsenses/ruby-1.9.1-p243/release/bin $path)
#path=(/home/user/clearsenses/ruby-1.8.6-p383/release/bin $path)
#export RUBYLIB=/home/user/clearsenses/ruby-1.8.6-p383/release/lib
#export GEM_HOME=/home/user/research/doublecheq/GEMS
#export GEM_HOME=/home/user/clearsenses/JAMBOOL_GEMS
#export GEM_HOME=/home/user/clearsenses/GEMS_Aug_2010
#export GEM_HOME=/home/user/clearsenses/GEMS_Mar_2011
#export GEM_HOME=/home/user/clearsenses/GEMS_Mar_2011_1_6_2
#export GEM_HOME=/home/user/clearsenses/GEMS_Sep_2011
#export GEM_HOME=/tmp/3
#export GEM_HOME=/home/user/clearsenses/GEMS-1.8
#export GEM_PATH=$GEM_HOME
#export RUBY_SOURCE_DIR=/home/user/clearsenses/ruby-enterprise-1.8.7-20090928/source/
#path=($GEM_PATH/bin $path /usr/sbin/php-fpm/bin "/home/user/tools/Sublime Text 2")

#variables that need to be set for intellij - Ubuntu
#export JDK_HOME=/usr/lib/jvm/java-6-sun-1.6.0.15/
#export M2_HOME=/usr/share/maven2/

# functions
setenv() { export $1=$2 }  # csh compatibility

#bash style ctrl-a (beginning of line) and ctrl-e (end of line)
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

#home and end keys for mrxvt - the way I detected this was by typing "cat" and enter and then pressed home and end keys
#cut-paste-rinse-repeat
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line
# key bindings

# Emulate tcsh's backward-delete-word
tcsh-backward-delete-word () {
    #local WORDCHARS="${WORDCHARS:s#/#}"
    #local WORDCHARS='*?_[]~\/!#$%^<>|`@#$%^*()+?'
    local WORDCHARS="${WORDCHARS:s#/#}"
    zle backward-delete-word
}

tcsh-backward-word () {
    local WORDCHARS="${WORDCHARS:s#/#}"
    zle emacs-backward-word
}

tcsh-forward-word () {
    local WORDCHARS="${WORDCHARS:s#/#}"
    zle emacs-forward-word
}

zle -N tcsh-backward-delete-word
zle -N tcsh-backward-word
zle -N tcsh-forward-word

# for escape backspace (delete a word) behavior similar to tcsh
bindkey '\e^?' tcsh-backward-delete-word
#for ctrl leftarrow and rightarrow navigation 
bindkey ';5D' tcsh-backward-word
bindkey ';5C' tcsh-forward-word

#if this is uncommented, it will ignore the stop-at-special-chars
#bindkey '\e^H' backward-delete-word

#uncomment this to have a nice update script that will cause ur zshrc to update from a central location

#selfupdate(){
#        URL="http://stuff.mit.edu/~jdong/misc/zshrc"
#        echo "Updating zshrc from $URL..."
#        echo "Press Ctrl+C within 5 seconds to abort..."
#        sleep 5
#        cp ~/.zshrc ~/.zshrc.old
#        wget $URL -O ~/.zshrc
#        echo "Done; existing .zshrc saved as .zshrc.old"
#}
#
#rsync -tzhhP rsync://cdimage.ubuntu.com/cdimage/daily/20090420.1/jaunty-alternate-i386.iso .
#mkdir -m 0700 /dev/cgroup/cpu/user/$$
#echo $$ > /dev/cgroup/cpu/user/$$/tasks



#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && \. "$HOME/.rvm/scripts/rvm"
eval "$(rbenv init -)"

#depends on history-substring-search plugin
zle -N history-substring-search-up
zle -N history-substring-search-down

bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down
