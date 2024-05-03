################################
# Build the sys161 toolchain
################################
FROM ubuntu:22.04 AS base

# Install required dependencies for building toolchain
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
        bmake \
        build-essential \
        coreutils \
        gdb \
        gdbserver \
        libmpc-dev \
        ncurses-dev \
        sudo \
        vim \
        wget \    
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV DEBIAN_FRONTEND=

# Set environment variables. If you change these, also update docker-compose.yml accordingly.
ENV WORKSPACE_DIR=/workspace
ENV OS161_DEPENDENCIES_DIR=/os161_dependencies
ENV OS161_SRC=$WORKSPACE_DIR/os161/src

# TODO: Build sys161 toolchain inside the Dockerfile

# Add OS161 tools to PATH
ENV PATH=${OS161_DEPENDENCIES_DIR}/tools/os161/bin:${OS161_DEPENDENCIES_DIR}/tools/sys161/bin:${PATH}

###############################################
# Build the image used for the devcontainer
###############################################
FROM base AS dev

# Install development dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
        bash-completion \
        cscope \
        git \
        nodejs \
        openssh-client \
        tree \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a new user and give them sudo permissions without password
# These might need to change if the UID and GID do not match the host user
ARG UID=1000
ARG GID=1000

ENV USERNAME=osdev
ENV HOME=/home/$USERNAME
RUN groupadd --gid $GID $USERNAME \
    && useradd -s /bin/bash --uid $UID --gid $GID -m $USERNAME && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" >> /etc/sudoers

# Set new user as the default user for the container
USER $USERNAME

# Copy config contents into home directory
WORKDIR $HOME
COPY --chown=${USERNAME}:${USERNAME} config .

# Set the default command to open a bash terminal
CMD ["/bin/bash"]
