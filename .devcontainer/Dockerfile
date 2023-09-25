# Use the official Ubuntu 18.04 base image
FROM ubuntu:18.04

# Install dependencies. Add any extra dependencies here.
# Remove apt cache to reduce the bloat of image size.
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
        openssh-client \
        sudo \
        tree \
        tmux \
        vim \
        wget \    
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a new user and give them sudo permissions without password
ARG UID=1000
ARG GID=1000

ENV USERNAME=osdev
ENV HOME=/home/$USERNAME
RUN groupadd --gid $GID $USERNAME \
    && useradd -s /bin/bash --uid $UID --gid $GID -m $USERNAME && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" >> /etc/sudoers

ENV DEBIAN_FRONTEND=

# Set new user as the default user for the container
USER $USERNAME

# Copy config contents into home directory
WORKDIR $HOME
COPY --chown=${USERNAME}:${USERNAME} config .

# Update .bashrc
RUN ./update-bashrc.sh

ENV WORKSPACE_DIR=/workspace
ENV OS161_SRC=$WORKSPACE_DIR/os161/src
WORKDIR $WORKSPACE_DIR

# Set the default command to open a bash terminal
CMD ["/bin/bash"]
