# OS161 Devcontainer

![Build Image](https://github.com/DFriend01/os161_devcontainer/actions/workflows/build_base_image.yml/badge.svg)

A development environment using VS Code devcontainers for OS161. Check out the [wiki on GitHub](https://github.com/DFriend01/os161_devcontainer/wiki)
for more in depth instructions on setup and usage.

## Quick Start

If you are already familiar with devcontainers and have Docker installed, these instructions
will get you started.

1. Clone this repository and place your OS161 source code in `os161/src`:

    ```bash
    git clone https://github.com/DFriend01/os161_devcontainer.git
    cd os161_devcontainer/os161 && git clone <REPO URL> src
    ```

    where `<REPO URL>` is replaced by the repository containing your OS161 source.

2. Build and open the devcontainer in VS Code:

    `ctrl + shift + p` > `Dev Containers: Rebuild and Reopen in Container`

3. Once the devcontainer is build, open `os161.code-workspace` and click the
`Open Workspace` button on the bottom-right corner.

4. Build your kernel: `ctrl + shift + b`

5. Run your kernel with the VS Code launch configuration `Run OS161`

## Developing the Base Image

The devcontainer image uses a base image that is pulled from the GitHub
Container Repository. If you want to change and build the base image
locally, open `.devcontainer/docker-compose.yml` and change the argument
`DEVCONTAINER_BASE_IMAGE` to have a value of `base`.
