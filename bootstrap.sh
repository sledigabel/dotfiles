#!bin/zsh

# This script is used to bootstrap the environment for the project
which ansible >/dev/null 2>&1 || {
  echo "Ansible is not installed. Installing Ansible..."
  python3 -m pip install --user ansible
  echo "Ansible installed successfully."
  # find out where the ansible executable is
  ansible_path=$(python3 -m site --user-base)/bin
  echo "Ansible executable path: $ansible_path"
  export PATH="$ansible_path:$PATH"
  ansible-playbook -i ansible/inventory ansible/playbook.yml
  exit 0
}

# If Ansible is already installed, run the playbook
ansible-playbook -i ansible/inventory ansible/playbook.yml

