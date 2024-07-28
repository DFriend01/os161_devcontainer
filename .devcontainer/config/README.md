# Adding your own dotfiles

The `.devcontainer/config` directory contains configuration files that are copied into the home
directory of the docker container. You may place your own dotfiles here to use them inside
the devcontainer.

Creating and/or editing any files within the home directory directly inside the devcontainer will
not work because the home directory is not persisted. When any changes are made in the `config`
directory, you will need to rebuild the docker container with the VS Code command
`Dev Containers: Rebuild and Reopen in Container`. Observe that your dotfiles are now populated
in `$HOME`.
