# Devcontainer Configuration

## Purpose

The `.devcontainer/config` directory contains configuration files that are copied into the home
directory of the docker container. You may place your own dotfiles here to use them inside
the devcontainer. Instructions are below.

## How to Configure the Devcontainer

Be sure to follow the instructions here to configure files in the home directory inside the devcontainer.
Creating and/or editing any files within `/home/osdev` inside the devcontainer will not work because the home
directory is not persisted as part of a docker volume. It would work temporarily, but you will lose any changes
upon stopping the container.

When any changes are made in the `config` directory, you will need to rebuild the docker container with
the VS Code command `Dev Containers: Rebuild and Reopen in Container`. Observe that your dotfiles are
now populated in `/home/osdev`.

### Add or Edit Dotfiles

Add your own dotfiles to the devcontainer simply by dropping them inside the `config` directory and
rebuilding the devcontainer. Likewise for editing dotfiles.

### Sys161 Config File

The `sys161.conf` file is populated inside `/home/osdev` like the other config files.
It will automatically be copied to `$WORKSPACE_DIR/os161/root` during the setup process.
If a configuration file already exists inside the root directory, it will not be ovewritten.
