#/bin/bash

function add_line_to_bashrc() {
    # Accepts one argument which is the line to add to the .bashrc
    line_content=$1
    echo "" >> ${HOME}/.bashrc
    echo ${line_content} >> ${HOME}/.bashrc
}

# Add path to OS161 tools
add_line_to_bashrc "PATH=$HOME/tools/os161/bin:$HOME/tools/sys161/bin:$PATH"
