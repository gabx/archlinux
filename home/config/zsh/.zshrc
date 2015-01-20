# File: ~/.zshrc @ hortensia  
# Last modified: 2014-05-02                           

# source zsh start-up file initzsh if it exists
if [[ -e "$XDG_CONFIG_HOME/zsh/.initzsh" ]]; then
. "$XDG_CONFIG_HOME/zsh/.initzsh"
fi

# Perl path
PATH="/home/gabx/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/developement/language/perl/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/developement/language/perl/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/developement/language/perl/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/developement/language/perl/perl5"; export PERL_MM_OPT;


# r-plugin-setup
# Change the TERM environment variable (to get 256 colors) and make Vim
# connecting to X Server even if running in a terminal emulator (to get
# dynamic update of syntax highlight and Object Browser):

# add gem path and gen home
PATH="/home/gabx/.config/gem/ruby/2.1.0/bin:$PATH"; export PATH;
export GEM_HOME=/home/gabx/.config/gem/ruby/2.1.0

# set i3 socket path
# export I3_SOCKET_PATH=$XDG_RUNTIME_DIR/i3/ipc-socket


