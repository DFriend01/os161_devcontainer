# OS161 Devcontainer

The OS161 devcontainer allows users to install their OS161 source code inside a docker
container without the hassle of needing to install on their local host directly. The
devcontainer has been tested on WSL2.

## How it works

### Overview

The devcontainer can be integrated with VS Code, but it can also be used with only the
command line interface. Setup and run instructions will follow this section.

The devcontainer uses Ubuntu 18.04 as the base image. From there, additional dependencies
are installed as part of the docker image. Docker virtualizes the operating system, meaning
that when inside the devcontainer, it is almost like having the Ubuntu 18.04 OS installed
on your machine (with some limitations).

### Persistent Storage

Docker containers by themselves are incapable of having persisting storage. Once a container is stopped,
the data inside is wiped. The devcontainer handles this issue by utilizing docker volumes, which
allows persistent storage between multiple uses of the devcontainer. As is, there are two docker volumes:

1. The first docker volume is used on the `os161_devcontainer` directory, which synchronizes everything
inside this directory between the devcontainer and the user's host machine. Changes made in the devcontainer
are observed in the local host, and vice versa. The volume is mapped between the location of `os161_devcontainer`
on your host machine, and the directory specified by the environment variable `$WORKSPACE_DIR` inside the
devcontainer.

2. The second docker volume is used on the home directory for the `osdev` user inside the devcontainer.
Unlike the first volume, this volume is stored as an anonymous volume and is handled by docker.

> [!WARNING]
> Any data that is not stored in either `$WORKSPACE_DIR` or `/home/osdev` will be wiped out upon
> stopping the container. If you want to store data in another location, you will need to edit
> the `docker-compose.yml` file to add another volume and rebuild the container.

## Prerequisites

1. Docker must be installed. The installation process looks different depending on the operating system:
    - Windows WSL2
    - MacOS
    - Linux

2. VS Code must be installed to take full advantage of all the devcontainer's features. However, it is
possible to use the devcontainer without VS Code using the command line interface only.

## Setup

1. Ensure that the docker daemon is running. You can check that `docker --version` returns an error-free
output in the CLI. If you installed docker desktop for Windows or MacOS, starting it will start the
docker daemon.

2. Clone this repository:

```
git clone https://github.com/DFriend01/os161_devcontainer.git
```

3. Clone your OS161 source code into the devcontainer:

```
cd os161_devcontainer/os161
git clone <REPO URL> src
```

> [!IMPORTANT]
> Your os161 code must be contained inside `$WORKSPACE_DIR/os161/src`.

4. Build the devcontainer and enter it:

    a. **With VS Code**
        
        - Start by opening VS Code with `os161_devcontainer` as the project directory: `code os161_devcontainer`.
        - VS Code should prompt you to reopen in the devcontainer -- accept the prompt. If VS Code does not prompt
          you, then run the VS Code command `ctrl + shift + p` then `Dev Containers: Rebuild and Reopen in Container`.
        - To stop the devcontainer, just close VS Code.

    b. **With CLI**

        - Start the devcontainer service:

        ```
        cd os161_devcontainer/.devcontainer
        docker compose up --detach
        ```

        - Get the container ID of the devcontainer. Execute `docker ps` and copy the container ID.
        - Enter the devcontainer:

        ```
        docker exec -it <CONTAINER ID> /bin/bash
        ```

        - To stop the devcontainer:
            - Exit the devcontainer with `exit`
            - On your local host: `cd os161_devcontainer/.devcontainer`
            - Execute `docker compose down`

5. **Inside the devcontainer**, run the setup script:

```
cd $WORKSPACE_DIR/scripts
./setup.sh
```

6. Source the `.bashrc` file or reopen a new terminal inside the devcontainer:

```
source /home/osdev/.bashrc
```

    Confirm that the dependencies installed correctly by observing `which sys161` outputting
    a valid path. Also take a look at `~/tools`.

7. Build your kernel. The setup script automatically fetches a configuration script `sys161.conf` located in
`$WORKSPACE_DIR/os161`. Either copy it into `$WORKSPACE_DIR/os161/root` after building, or use your own
configuration file if you have one already.

## VS Code Tasks

The devcontainer implements VS Code tasks. The task definitions are located in `.vscode/tasks.json`. Be sure to
take a look at the tasks available, or even add your own!

Run a VS Code task by:
- Entering `ctrl + shift + p`
- Selecting `Tasks: Run Task`
- Selecting the desired task to run

> [!NOTE]
> When building for the first time, sometimes the VS Code tasks that do the build process won't work until
> you build for the first time. The reason as of right now is unknown. If you encounter any issues, just
> build manually in the CLI and try the tasks later.
