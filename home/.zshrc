# File: ~/.zshrc   
# Last modified: 2013-10-02                            

# source zsh start-up file initzsh if it exists
if [[ -e "$XDG_CONFIG_HOME/zsh/.initzsh" ]]; then
. "$XDG_CONFIG_HOME/zsh/.initzsh"
fi

# source user shell customization file if it exists
#if [[ -e "$XDG_CONFIG_HOME/profile" ]] ; then
#. "$XDG_CONFIG_HOME/profile"
#fi

# source user environment variable file if it exists
#if [[ -e "$XDG_CONFIG_HOME/environment" ]] ; then
#. "$XDG_CONFIG_HOME/environment"
#fi