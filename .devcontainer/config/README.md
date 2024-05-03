# Devcontainer Configuration

## Purpose

The `.devcontainer/config` directory contains configuration files that are copied into the home
directory of the docker container. You may place your own dotfiles here to use them inside
the devcontainer. Instructions are below.

## How to Configure the Devcontainer

Be sure to follow the instructions here to configure files in the home directory inside the devcontainer.
Creating and/or editing any files within `/home/osdev` inside the devcontainer will not work because the home
directory is not persisted. It would work temporarily, but you will lose any changes upon stopping the container.

When any changes are made in the `config` directory, you will need to rebuild the docker container with
the VS Code command `Dev Containers: Rebuild and Reopen in Container`. Observe that your dotfiles are
now populated in `/home/osdev`.

### Add or Edit Dotfiles

Add your own dotfiles to the devcontainer simply by dropping them inside the `config` directory and
rebuilding the devcontainer. Likewise for editing dotfiles.
