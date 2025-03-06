# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
#

# zsh profiling
# zmodload zsh/zprof

PARENTPROCESS=$(ps -p `ps -p $$ -o ppid=` -o comm=)

if [ -n "${ZSH_TMUX_AUTOSTARTED:-}" ]
then
  #  if [ "${TERM_PROGRAM}" = "iTerm.app" ] || [ "${TERM_PROGRAM}" = "alacritty" ] || [ "${TERM_PROGRAM}" = "tmux" ]
  #  then
  #    eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/seb.omp.yaml)"
  # else
   ZSH_THEME="sorin"
  # fi
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
export PATH="/Users/sebastienledigabel/.pyenv/bin:${HOME}/.bin:${GOPATH}/bin:/opt/homebrew/bin:${PATH}:${TMUX_SESSION_DIR:-/Users/sebastienledigabel}/node_modules/.bin:${HOME}/.cargo/bin"
export NODE_PATH="/opt/homebrew/lib/node_modules"
eval "$(pyenv init -)"
# https://github.com/pyenv/pyenv-virtualenv/issues/259#issuecomment-1007432346
# eval "$(pyenv virtualenv-init -| sed s/precmd/precwd/g)"
export SAVEHIST=5000
export ZSH=${HOME}/.oh-my-zsh
export VIRTUALENVWRAPPER_VIRTUALENV=/Users/sebastienledigabel/.pyenv/shims/virtualenv
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
export WORKON_HOME=~/.virtualenvs
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

export NVM_DIR="$HOME/.nvm"
export DISABLE_UNTRACKED_FILES_DIRTY=true

[ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# for virtualenvwrapper
[ -e "/opt/homebrew/bin/virtualenvwrapper.sh" ] && source /opt/homebrew/bin/virtualenvwrapper.sh
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


# git setup
gitlog() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}


plugins=(
  # aws
  asdf
  brew
  colorize
  colored-man-pages
  # docker
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
  # httpie
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
  if [ -n "${SKIP_TMUX}" ]; then
  elif [ "${TERM_PROGRAM}" = "iTerm.app" ] || [ "${TERM}" = "xterm-kitty" ] || [ "${TERM}" = "xterm-ghostty" ]; then
  # if [ "${TERM_PROGRAM}" = "iTerm.app" ] || [ "${TERM}" = "xterm-kitty" ]; then
    ZSH_TMUX_AUTOSTART=true
    ZSH_TMUX_AUTOSTART_ONCE=true
    zstyle :omz:plugins:ssh-agent agent-forwarding on
    # zstyle :omz:plugins:ssh-agent ssh-add-args -K
    zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain --apple-use-keychain
    zstyle :omz:plugins:ssh-agent identities id_rsa_ss_github id_rsa_github_perso bitbucket id_vps home-assistant
    # we are within the terminal but not in tmux yet. starting the ssh-agent in there.
    plugins=(
      ssh-agent
      tmux
    )
  elif [ "${TERM_PROGRAM}" = "tmux" ]; then
  fi
fi
#
# run OMZ
source $ZSH/oh-my-zsh.sh
# unalias buf

alias ls='lsd -g'
alias vi=lnvim
alias vim=nvim
alias vimdiff="nvim -d"
alias obfuscate="sed -Ee 's/[0-9]+(\.[0-9]+){3}/OBFUSCATED_IP/g'"
alias ssh="ssh -o StrictHostKeyChecking=no"
alias less="bat"
alias jira='JIRA_API_TOKEN="$(security find-generic-password -a ${USER} -s jira_token -w)" /opt/homebrew/bin/jira'
alias ghostty_config="vim ~/.config/ghostty/config"

# . ~/.asdf/plugins/java/set-java-home.zsh

autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit

# source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
# zprof > ~/zshProfile
