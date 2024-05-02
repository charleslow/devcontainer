#!/bin/bash

# ideally the brew install would be done in the Dockerfile, but somehow that doesn't work
brew tap databricks/tap
brew install databricks

# install poetry environments
poetry install

# setup git
echo setting up git:
read -p "git user name: " git_username
read -p "git user email: " git_user_email
git config --global user.name "$git_username"
git config --global user.email "$git_user_email"
git config --global pull.rebase false

# setup databricks CLI
echo setting up databricks cli:
read -p "databricks host: " databricks_host
stty -echo
printf "databricks CLI token: "
read databricks_cli_token
printf "\n"
stty echo
cat <<EOF >> ~/.databrickscfg
[DEFAULT]
host = $databricks_host
token = $databricks_cli_token
jobs-api-version = 2.0
EOF

# setup aliases
echo "setting up aliases..."
cat <<EOF >> ~/.bashrc
penv() {
    source "\$( poetry env list --full-path | egrep '(Activated)?' | cut -d' ' -f1 )/bin/activate";
}
alias gb='git branch'
alias gc='git checkout'
alias gnb='git checkout -b'
alias ll='ls -la'
alias gbp='git branch | grep -v "main" | xargs git branch -D'
alias k='kubectl'
alias kg='kubectl get'
EOF

# setup spark
cat <<EOF >> ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/default-java
EOF