# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
#

PARENTPROCESS=$(ps -p `ps -p $$ -o ppid=` -o comm=)

if [ -n "${ZSH_TMUX_AUTOSTARTED:-}" ]
then
   if [ "${TERM_PROGRAM}" = "iTerm.app" ] || [ "${TERM_PROGRAM}" = "alacritty" ] || [ "${TERM_PROGRAM}" = "tmux" ]
   then
     ZSH_THEME="powerlevel10k/powerlevel10k"
     # ZSH_THEME="alanpeabody"
     [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
     if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
       source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
     fi
  else
   ZSH_THEME="sorin"
  fi
fi
# ZSH_THEME="sorin"


# http://zsh.sourceforge.net/Doc/Release/Options.html#Options
setopt alwaystoend
setopt autocd
setopt autopushd
setopt chasedots
setopt combiningchars
setopt completeinword
# setopt completionwaitingdots
setopt correct
setopt extended_glob
setopt extendedhistory
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt histverify
setopt incappendhistory
setopt interactive
setopt interactivecomments
setopt login
setopt longlistjobs
setopt menucomplete
setopt monitor
setopt noflowcontrol
setopt promptsubst
setopt pushdignoredups
setopt pushdminus
setopt sharehistory
setopt zle

export EDITOR=nvim
export FZF_DEFAULT_OPTS="--layout=reverse --preview-window='right:60%' --preview 'bat' --border=rounded"
export GOPATH="$HOME/dev/go"

export GPG_TTY=$(tty)
export HISTFILE=~/.zsh_history
export HISTSIZE=5000
# export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export LC_ALL=en_GB.UTF-8
# export PATH="/Users/sebastienledigabel/.pyenv/shims:${HOME}/.bin:${GOPATH}/bin:${PATH}:${HOME}/nvim-osx64/bin:/usr/local/kubebuilder/bin:$(npm bin)"
export PATH="/Users/sebastienledigabel/.pyenv/bin:${HOME}/.bin:${GOPATH}/bin:${PATH}:${HOME}/nvim-osx64/bin:/usr/local/kubebuilder/bin:${TMUX_SESSION_DIR:-/Users/sebastienledigabel}/node_modules/.bin:${HOME}/.cargo/bin"
eval "$(pyenv init -)"
# https://github.com/pyenv/pyenv-virtualenv/issues/259#issuecomment-1007432346
eval "$(pyenv virtualenv-init -| sed s/precmd/precwd/g)"
export SAVEHIST=5000
# export TERM="xterm-256color"
export ZSH=${HOME}/.oh-my-zsh
export VIRTUALENVWRAPPER_VIRTUALENV=/Users/sebastienledigabel/.pyenv/shims/virtualenv
# export VIRTUALENVWRAPPER_PYTHON="/Users/sebastienledigabel/.pyenv/shims/python3"
# export CC=`which gcc-11`
# export LDFLAGS="-L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib"
# export CPPFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix bzip2)/include"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
export WORKON_HOME=~/.virtualenvs
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

export NVM_DIR="$HOME/.nvm"
export DISABLE_UNTRACKED_FILES_DIRTY=true
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

# for zsh-highlighters
[ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# for zsh-git-prompt
# [ -f "/usr/local/opt/zsh-git-prompt/zshrc.sh" ] && source "/usr/local/opt/zsh-git-prompt/zshrc.sh"
# for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# for virtualenvwrapper
[ -e "/opt/homebrew/bin/virtualenvwrapper.sh" ] && source /opt/homebrew/bin/virtualenvwrapper.sh
# iterm2 integration
[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
# extra sources
if [ -d "${HOME}/.source" ]
then
  for source_file in ${HOME}/.source/*.sh
  do
    source ${source_file}
  done
fi

# for zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# start the ssh-agent if not started already
[ -z "${SSH_AUTH_SOCK}" ] && eval $(ssh-agent)

alias ls='lsd'
# alias ls="ls -G -@"
alias vi=nvim
alias vim=nvim
alias vimdiff="nvim -d"
alias obfuscate="sed -Ee 's/[0-9]+(\.[0-9]+){3}/OBFUSCATED_IP/g'"
alias ssh="ssh -o StrictHostKeyChecking=no"
alias less="bat"

# git setup
gitlog() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}


plugins=(
  # aws
  # asdf
  brew
  colorize
  colored-man-pages
  docker
  # docker-compose
  # git
  # git-extras
  golang
  # helm
  # kubectl
  # macos
  # minikube
  # node
  # npm
  # ruby
  # rvm
  # rbenv
  # pip
  # python
  history
  httpie
  safe-paste
  tmux
  # virtualenv
  # virtualenvwrapper
  # zsh-autosuggestions
  # zsh-syntax-highlighting
)

if [ "${PARENTPROCESS##*/}" = "nvim" ] || [ "${PARENTPROCESS##*/}" = "bash" ]
 then ZSH_TMUX_AUTOSTART=false
else
  if [ "${TERM_PROGRAM}" = "iTerm.app" ]; then
    ZSH_TMUX_AUTOSTART=true
    ZSH_TMUX_AUTOSTART_ONCE=true
    zstyle :omz:plugins:ssh-agent agent-forwarding on
    # zstyle :omz:plugins:ssh-agent ssh-add-args -K
    zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain --apple-use-keychain
    zstyle :omz:plugins:ssh-agent identities id_rsa_ss_github id_rsa_github_perso bitbucket id_vps
    # we are within the terminal but not in tmux yet. starting the ssh-agent in there.
    plugins=(
      ssh-agent
      tmux
    )
  elif [ "${TERM_PROGRAM}" = "tmux" ]; then
  fi
fi

# run OMZ
source $ZSH/oh-my-zsh.sh
# eval "$(starship init zsh)"
. ~/.asdf/plugins/java/set-java-home.zsh

autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit

