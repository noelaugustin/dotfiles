#
# .zshrc
#
# @author Jeff Geerling
#

# Colors.
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Don't require escaping globbing characters in zsh.
unsetopt nomatch



# Custom $PATH with extra locations.
export PATH=/opt/homebrew/bin:$HOME/Library/Python/3.12/bin:/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:/usr/local/git/bin:$HOME/.composer/vendor/bin:$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH
# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi


# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Super useful Docker container oneshots.
# Usage: dockrun, or dockrun [centos7|fedora27|debian9|debian8|ubuntu1404|etc.]
# Run on arm64 if getting errors: `export DOCKER_DEFAULT_PLATFORM=linux/amd64`
dockrun() {
 docker run -it geerlingguy/docker-"${1:-ubuntu1604}"-ansible /bin/bash
}

# Enter a running Docker container.
function denter() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a container ID or name."
     return 0
 fi

 docker exec -it $1 bash
 return 0
}

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

# Allow Composer to use almost as much RAM as Chrome.
export COMPOSER_MEMORY_LIMIT=-1

# Ask for confirmation when 'prod' is in a command string.
#prod_command_trap () {
#  if [[ $BASH_COMMAND == *prod* ]]
#  then
#    read -p "Are you sure you want to run this command on prod [Y/n]? " -n 1 -r
#    if [[ $REPLY =~ ^[Yy]$ ]]
#    then
#      echo -e "\nRunning command \"$BASH_COMMAND\" \n"
#    else
#      echo -e "\nCommand was not run.\n"
#      return 1
#    fi
#  fi
#}
#shopt -s extdebug
#trap prod_command_trap DEBUG
source <(fzf --zsh)

# Set SSH_AUTH_SOCK for Bitwarden SSH agent on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    export SSH_AUTH_SOCK=/Users/naugustin/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
    export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"
fi
