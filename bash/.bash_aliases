# Adds an alias to the current shell and to this file.
# Borrowed from Mislav (http://github.com/mislav/dotfiles/tree/master/bash_aliases)
add-alias ()
{
   local name=$1 value=$2
   echo "alias $name='$value'" >> ~/.bash_aliases
   eval "alias $name='$value'"
   alias $name
}

############################################################
## List
############################################################

if [[ `uname` == 'Darwin' ]]; then
   alias ls="ls -G"
   # good for dark backgrounds
   export LSCOLORS=gxfxcxdxbxegedabagacad
   alias l="ls"
   alias ll="ls -lh"
   alias la="ls -a"
   alias lal="ls -alh"
fi

############################################################
## Git
############################################################

alias g="git"
alias gb="git branch -a -v"
alias gbc="git checkout -b "
alias gc="git commit -v"
alias gca="git commit -v -a"
alias go='git checkout '
alias gd="git diff"
alias gk='gitk --all&'
alias gl="git pull"
alias glr="git pull --rebase"
alias gp="git push"
alias gs="git status -s"
alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ggs="gg --stat"
alias gsl="git shortlog -sn"
alias gw="git whatchanged"
alias gsu="git submodule update --init --recursive"
alias unpushed="git log --branches --not --remotes --simplify-by-decoration --decorate --oneline"

# Useful report of what has been committed locally but not yet pushed to another
# branch.  Defaults to the remote origin/master.  The u is supposed to stand for
# undone, unpushed, or something.
function gu {
  local branch=$1
  if [ -z "$1" ]; then
    branch=master
  fi
  if [[ ! "$branch" =~ "/" ]]; then
    branch=origin/$branch
  fi
  local cmd="git cherry -v $branch"
  echo $cmd
  $cmd
}

function gco {
  if [ -z "$1" ]; then
    git checkout master
  else
    git checkout $*
  fi
}

function st {
  if [ -d ".svn" ]; then
    svn status
  else
    git status
  fi
}

############################################################
## Subversion
############################################################

# Remove all .svn folders from directory recursively
alias svn-clean='find . -name .svn -print0 | xargs -0 rm -rf'

alias svd='svn diff'
alias svs='svn status'
alias svu='svn update'
alias svl='svn log'
alias svi='svn info'
alias svci='svn ci'
alias svco='svn co'


############################################################
## OS X
############################################################

# Get rid of those pesky .DS_Store files recursively
alias dstore-clean='find . -type f -name .DS_Store -print0 | xargs -0 rm'

# Track who is listening to your iTunes music
alias whotunes='lsof -r 2 -n -P -F n -c iTunes -a -i TCP@`hostname`:3689'

############################################################
## Ruby
############################################################

alias r="rake"
alias a="autotest -q"

function gemdir {
  echo `rvm gemdir`
}

function gemfind {
  local gems=`gemdir`/gems
  echo `ls $gems | grep -i $1 | sort | tail -1`
}

# Use: gemcd <name>, cd's into your gems directory
# that best matches the name provided.
function gemcd {
  pushd `gemdir`/gems/`gemfind $1`
}

# Use: gemdoc <gem name>, opens the rdoc of the gem
# that best matches the name provided.
function gemdoc {
  gnome-open `gemdir`/doc/`gemfind $1`/rdoc/index.html
}

############################################################
## rvm
############################################################

alias rvmj='rvm use 1.7.4'
alias rvmm='rvm use 1.9.3'

############################################################
## Bundler
############################################################

alias b="bundle"
alias bi="b install"
alias bu="b update"
alias be="b exec"

############################################################
## Rails
############################################################

alias rs="rails server"
alias rg="rails generate"
alias rc="rails console"
alias tl='tail -f log/development.log'

############################################################
## Miscellaneous
############################################################

if [ -f /Applications/Emacs.app/Contents/MacOS/Emacs ]; then
  alias emacs='TERM=xterm-256color /Applications/Emacs.app/Contents/MacOS/Emacs'
  alias emacsclient='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n'
fi

alias grep='GREP_COLOR="1;37;41" grep --color=auto'
alias wgeto="wget -q -O -"
alias sha1="openssl dgst -sha1"
alias sha2="openssl dgst -sha256"
alias b64="openssl enc -base64"
alias 256color="export TERM=xterm-256color"

alias flushdns='dscacheutil -flushcache'

alias tf='tail -f'

if [[ `uname` != 'Darwin' ]]; then
  alias ack='ack-grep'
  alias o='gnome-open'
fi

alias em='emacsclient -n'
export EDITOR='emacsclient'

function serve {
  local port=$1
  : ${port:=3000}
  ruby -rwebrick -e"s = WEBrick::HTTPServer.new(:Port => $port, :DocumentRoot => Dir.pwd); trap(%q(INT)) { s.shutdown }; s.start"
}

alias open='gnome-open'

function explain {
    # base url with first command already injected
    # $ explain tar
    #   => http://explainshel.com/explain/tar?args=
    url="http://explainshell.com/explain/$1?args="

    # removes $1 (tar) from arguments ($@)
    shift;

    # iterates over remaining args and adds builds the rest of the url
    for i in "$@"; do
        url=$url"$i""+"
    done

    # opens url in browser
    # run it in sub-shell in order to avoid PID annoying output
    (open $url &>/dev/null &)
}

alias ibus_restart='ibus-daemon -rxd'

alias psg='ps aux | grep'

alias cdv='cd ~/work/vulcan/'
alias cdva='cdv ; cd vulcan-affiliate'
alias cdvb='cdv ; cd vulcan-bing'
alias cdvc='cdv ; cd vulcan-common'
alias cdvd='cdv ; cd vulcan-data-interface'
alias cdvg='cdv ; cd vulcan-google'
alias cdvn='cdv ; cd vulcan-benchmark'
alias cdvr='cdv ; cd reporting'
alias cdvs='cdv ; cd sales-master'
alias cdvt='cdv ; cd tracking'
alias cdvp='cdv ; cd transporter'

alias irbv="irb -r ~/work/vulcan/irb_vulcan.rb"
alias pryv="bundle exec pry -r ~/projects/vulcan/irb_vulcan.rb"

alias tst='VULCAN_ENV=test RAILS_ENV=test'
alias prod='VULCAN_ENV=production RAILS_ENV=production'

alias v='ruby bin/vulcan'

export GIT=git@github.com:info-sys
export SVN=http://svn/repos/vulcan

function svn_create_branch {
  svn cp $SVN/trunk $SVN/branches/$1
}

function svn_merge_branch {
  svn merge $SVN/branches/$1 .
}

alias svncb='svn_create_branch'
alias svmt='svn merge $SVN/trunk .'
alias svmtd='svmt --dry-run'
alias svmb='svn_merge_branch'
alias svmbd='svmb --dry-run'
alias svmbr='svmb --reintegrate'

alias winvm='sudo vmrun start /home/rohit/InfoSys\ Base/InfoSys\ WinXP\ Base/InfoSys\ WinXP\ Base.vmx'
############################################################
