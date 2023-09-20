# Use the official Ubuntu 18.04 base image
FROM ubuntu:18.04

# Install dependencies. Add any extra dependencies here.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
    bash-completion \
    bmake \
    cmake \
    cscope \
    build-essential \
    emacs \
    gdb \
    git \
    libmpc-dev \
    ncurses-dev \
    sudo \
    tmux \
    vim \
    wget

# Create a new user and give them sudo permissions without password
ARG UID=1000
ARG GID=1000

# You can change this if you want
ENV USERNAME=osdev

ENV HOME=/home/$USERNAME
RUN groupadd --gid $GID $USERNAME \
    && useradd -s /bin/bash --uid $UID --gid $GID -m $USERNAME && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" >> /etc/sudoers

ENV DEBIAN_FRONTEND=

# Set new user as the default user for the container
USER $USERNAME

# Compile OS161 dependencies and add to path
WORKDIR $HOME
COPY cs161-ubuntu-darwin.sh .

ENV WORKSPACE_DIR=/workspace
ENV OS161_SRC=$WORKSPACE_DIR/os161/src
WORKDIR $WORKSPACE_DIR
COPY .vscode ./.vscode
COPY setup.sh .

# Set the default command to open a bash terminal
CMD ["/bin/bash"]
