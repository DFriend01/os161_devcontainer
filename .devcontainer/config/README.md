# Devcontainer Configuration

## Purpose

The `.devcontainer/config` directory contains configuration files that are copied into the home
directory of the docker container.

## How to Configure the Devcontainer

Be sure to follow the instructions here to configure files in the home directory inside the devcontainer.
Creating and/or editing any files within `/home/osdev` inside the devcontainer will not work because the home
directory is not persisted as part of a docker volume. You will lose any changes upon stopping the container.

When any changes are made in the `config` directory, you will need to rebuild the docker container with
the VS Code command `Dev Containers: Rebuild and Reopen in Container`.

### Update the .bashrc

The `update-bashrc.sh` script is responsible for updating `~/.bashrc` inside the devcontainer. If you
want to update the bashrc inside the devcontainer, edit the script to do so.

For example, if you want to add `echo "Hello World!"` inside the bashrc, the following line should be
added inside the `update-bashrc.sh` script:

```bash
add_line_to_bashrc 'echo "Hello World!"'
```

### Add or Edit Dotfiles

Add your own dotfiles to the devcontainer simply by dropping them inside the `config` directory and
rebuilding the devcontainer. Likewise for editing dotfiles.

### Sys161 Config File

The `sys161.conf` file is copied to `/home/osdev`. It will automatically be copied to `$WORKSPACE_DIR/os161/root`
during the setup process. If a configuration file already exists inside the root directory, it will not be overridden.
