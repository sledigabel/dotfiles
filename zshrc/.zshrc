# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.

PARENTPROCESS=$(ps -p `ps -p $$ -o ppid=` -o comm=)

if [ -n "${ZSH_TMUX_AUTOSTARTED:-}" ]
then
   if [ "${TERM_PROGRAM}" = "iTerm.app" ] || [ "${TERM_PROGRAM}" = "alacritty" ] || [ "${TERM_PROGRAM}" = "tmux" ]
   then
     ZSH_THEME="powerlevel10k/powerlevel10k"
     [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
     if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
       source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
     fi
  else
   ZSH_THEME="sorin"
  fi
fi


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
# export GOROOT=$(${GOPATH}/bin/go1.17 env GOROOT)
export GPG_TTY=$(tty)
export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
export LC_ALL=en_GB.UTF-8
export PATH="/Users/sebastienledigabel/.pyenv/shims:${HOME}/.bin:${GOPATH}/bin:${PATH}:${HOME}/nvim-osx64/bin:/usr/local/kubebuilder/bin:$(npm bin)"
export SAVEHIST=5000
# export TERM="xterm-256color"
export ZSH=${HOME}/.oh-my-zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

# for zsh-highlighters
[ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# for zsh-git-prompt
[ -f "/usr/local/opt/zsh-git-prompt/zshrc.sh" ] && source "/usr/local/opt/zsh-git-prompt/zshrc.sh"
# for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# for virtualenvwrapper
[ -e "/usr/local/bin/virtualenvwrapper.sh" ] && source /usr/local/bin/virtualenvwrapper.sh
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
  aws
  brew
  colorize
  colored-man-pages
  docker
  docker-compose
  git
  git-extras
  golang
  helm
  kubectl
  macos
  minikube
  node
  npm
  ruby
  rvm
  rbenv
  pip
  python
  history
  httpie
  safe-paste
  tmux
  virtualenv
  # virtualenvwrapper
  zsh-autosuggestions
  # zsh-syntax-highlighting
)

if [ "${PARENTPROCESS##*/}" = "nvim" ] || [ "${PARENTPROCESS##*/}" = "bash" ]
 then ZSH_TMUX_AUTOSTART=false
else
  if [ "${TERM_PROGRAM}" = "iTerm.app" ]; then
    ZSH_TMUX_AUTOSTART=true
    ZSH_TMUX_AUTOSTART_ONCE=true
    zstyle :omz:plugins:ssh-agent agent-forwarding on
    zstyle :omz:plugins:ssh-agent ssh-add-args -K
    zstyle :omz:plugins:ssh-agent identities id_rsa_ss_github id_rsa_github_perso bitbucket
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

autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit

_saml2aws_bash_autocomplete() {
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$( ${COMP_WORDS[0]} --completion-bash ${COMP_WORDS[@]:1:$COMP_CWORD} )
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _saml2aws_bash_autocomplete saml2aws
