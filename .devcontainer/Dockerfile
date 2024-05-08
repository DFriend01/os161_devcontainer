###############################
# Build the os161 toolchain
###############################
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

# Set environment variables
ARG WORKSPACE_DIR
ARG OS161_DEPENDENCIES_DIR
ENV WORKSPACE_DIR=${WORKSPACE_DIR}
ENV OS161_DEPENDENCIES_DIR=${OS161_DEPENDENCIES_DIR}
ENV OS161_SRC=${WORKSPACE_DIR}/os161/src

# Build os161 toolchain inside the Dockerfile
COPY build_os161_toolchain.sh .
RUN bash build_os161_toolchain.sh \
    && mkdir -p ${OS161_DEPENDENCIES_DIR} \
    && mv ${HOME}/tools ${OS161_DEPENDENCIES_DIR} \
    && rm build_os161_toolchain.sh

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
        bear \
        clangd \
        git \
        nodejs \
        openssh-client \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a new user and give them sudo permissions without password
ARG UID
ARG GID
ARG USERNAME

ENV USERNAME=${USERNAME}
ENV HOME=/home/${USERNAME}
RUN groupadd --gid ${GID} ${USERNAME} \
    && useradd -s /bin/bash --uid ${UID} --gid ${GID} -m ${USERNAME} && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" >> /etc/sudoers

# Set new user as the default user for the container
USER ${USERNAME}

# Persist bash history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && sudo mkdir /commandhistory \
    && sudo touch /commandhistory/.bash_history \
    && sudo chown -R ${USERNAME} /commandhistory \
    && echo "$SNIPPET" >> "/home/${USERNAME}/.bashrc"

# Copy config contents into home directory
WORKDIR ${HOME}
COPY --chown=${USERNAME}:${USERNAME} config .

# Set the default command to open a bash terminal
CMD ["/bin/bash"]
