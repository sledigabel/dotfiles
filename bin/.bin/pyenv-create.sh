#!/opt/homebrew/bin/zsh
#
# script to create a pyenv virtualenv project and activate it

if [ "$#" -lt 1 ]; then
	echo "Need a python version"
	exit 1
fi

if [ "$(pyenv versions --bare | grep "$1")" = "" ]; then
	echo "Need a python version"
	exit 1
fi

PROJECT_NAME=$(basename "$TMUX_SESSION_DIR")

eval "$(pyenv virtualenv-init - | sed s/precmd/precwd/g)"
echo "Installing new pyenv virtualenv for $PROJECT_NAME"
pyenv virtualenv "${1}" "$PROJECT_NAME" || true
echo "installing all the cots for dev"
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'python-lsp-server'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'python-lsp-server[all]'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'isort'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'black'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'flake8'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'pycodestyle'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'pytest'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'pytest-mock'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'pytest-aiohttp'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'pytest-cov'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'coverage'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'pip-tools'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'python-lsp-black'
"$(pyenv root)/versions/$PROJECT_NAME"/bin/pip install 'python-lsp-isort'
echo
echo
echo "pyenv activate ${PROJECT_NAME}"
