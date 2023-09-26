# OS161 Devcontainer

The OS161 devcontainer allows users to install their OS161 source code inside a docker
container without the hassle of needing to install on their local host directly. It also
provides additional features like VS Code tasks that streamline many of the redunant tasks
that are common with developing OS161.

The devcontainer has been tested on WSL2.


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
allows persistent storage between multiple uses of the devcontainer. As is, there are two docker volumes
that the devcontainer uses:

1. The first is a [bind mount](https://docs.docker.com/storage/bind-mounts/) on the `os161_devcontainer` directory,
which synchronizes everything inside this directory between the devcontainer and the user's host machine. 
Changes made in the devcontainer are observed in the local host, and vice versa. The bind mount
is mapped between the location of `os161_devcontainer` on your host machine, and the directory
specified by the environment variable `$WORKSPACE_DIR` inside the devcontainer.

2. The second is a [named volume](https://docs.docker.com/storage/volumes/), which is used to persist the
directory specified by the environment variable `$OS161_DEPENDENCIES_DIR` which persists the compiled OS161 tools to avoid 
recompiling upon each rebuild of the docker container.

> [!WARNING]
> Any data that is not stored in `$WORKSPACE_DIR` or any of its subdirectories will be wiped out upon
> stopping the container. If you want to store data in another location inside the devcontainer,
> you will need to edit the `docker-compose.yml` file to add another volume and rebuild the container.
> Consult the [docker documentation](https://docs.docker.com/storage/volumes/#use-a-volume-with-docker-compose).

## Prerequisites

1. Docker must be installed. The installation process looks different depending on the operating system:
    - Windows 11
        - [Install WSL and Ubuntu](https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-11-with-gui-support#1-overview)
        - [Install Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
    - MacOS
        - [Install Docker Desktop](https://docs.docker.com/desktop/install/mac-install/)
    - Linux
        - [Install Docker Engine](https://docs.docker.com/engine/install/)
        - [Manage Docker as a Non-Root User](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)
        - [Configure to Start on Boot](https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot) (Optional)

2. [VS Code must be installed](https://code.visualstudio.com/download) to take full advantage
of all the devcontainer's features. However, it is possible to use the devcontainer without VS Code
using the command line interface only. If you are using VS Code, you must also install the
[Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

## Setup

1. Ensure that the docker daemon is running. You can check that `docker --version` returns an error-free
output in the CLI. If you installed docker desktop for Windows or MacOS, starting it will start the
docker daemon.

2. Clone this repository:

```
git clone https://github.com/DFriend01/os161_devcontainer.git
```

> [!IMPORTANT]
> If you are in Windows WSL, make sure that the devcontainer is cloned within the WSL network! If you
> clone in the Windows partition, docker will not work as expected. You can tell if you are in the
> Windows partition if:
>
> - The path outputed by the command `pwd` starts with `/mnt/c` if you are using the Ubuntu terminal
> - The current directory starts with `C:` or `/c` if you are using the command prompt, git bash, or powershell
>
> It is recommended that you install [Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/install)
> and use the Ubuntu profile when working in WSL. Also make sure that the starting directory is your home directory
> `~`. If not, you will need to change the starting directory field for the Ubuntu profile to
> `//wsl.localhost/<DISTRO NAME>/home/<USERNAME>`.
> See the [windows terminal documentation](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/profile-general#starting-directory).

3. Clone your OS161 source code into the devcontainer:

```
cd os161_devcontainer/os161
git clone <REPO URL> src
```

> [!IMPORTANT]
> Your os161 code must be contained inside `os161_devcontainer/os161/src`. Otherwise, you may get unexpected
> results when attempting to build.

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

> [!NOTE]
> When building the docker container, docker likes to hang sometimes. Changing the network connection
> sometimes helps. You could also try restarting the docker daemon, but the troubleshooting steps may vary from
> machine to machine.

5. **Inside the devcontainer**, run the setup script:

```
cd $WORKSPACE_DIR/scripts
./setup.sh
```

Alternativly, you can run the `Setup Workspace` VS Code task. See the section on
[VS Code tasks](#vs-code-tasks).

6. Confirm that the dependencies installed correctly by observing `which sys161` outputting
a valid path. Also take a look at `$OS161_DEPENDENCIES_DIR/tools`.

7. Build your kernel. You can either do it yourself following the
[instructions on the course website](https://people.ece.ubc.ca/~os161/os161-site/build-os161.html)
or run the [build task](#vs-code-tasks).

## VS Code Tasks

The devcontainer implements VS Code tasks. The task definitions are located in `.vscode/tasks.json`. Be sure to
take a look at the tasks available, or even add your own!

Run a VS Code task by:
- Entering `ctrl + shift + p`
- Selecting `Tasks: Run Task`
- Selecting the desired task to run

Performing a full build of the kernel is mapped to `ctrl + shif + b`, which is also the `Build` task.

## FAQs

### Where can I find my source code on my host machine after developing in the devcontainer?

Your work will be saved in the directory `os161_devcontainer/os161`. Everything inside the `$WORKSPACE_DIR`
directory in the devcontainer is synced to `os161_devcontainer/os161` on your local host.

### Where is my OS161 code stored in the devcontainer?

OS161 source code is stored in `$WORKSPACE_DIR/os161/src`. If you changed directories and do not remember
where the source code is, then change directories back to the workspace:

```bash
cd $WORKSPACE_DIR
```

### Where are the OS161 tools stored?

The OS161 tools are stored in `$OS161_DEPENDENCIES_DIR`. This directory is persisted in a docker volume,
so any changes made to the tools (i.e. if you desire to add symbolic links), those are also persisted.

### Will I need to run the setup script/task every time I start the devcontainer?

No! You only need to run it when:

- You are setting up the devcontainer for the first time; OR
- You delete the docker named volume that contains the compiled OS161 tools; OR
- You delete your `root` directory and/or your `sys161.conf` file

The script does check to make sure whether each setup step inside the script is necessary or not,
so there is no harm in running it again if you want to.

### How can I add my own dotfiles to the devcontainer?

See the [documentation on configuration](.devcontainer/config/README.md).

### How can I run VS Code commands and tasks?

`ctrl + shift + p` opens the command palette. Search your desired VS Code command and execute it.
If you want to execute a task, select the `Tasks: Run Task` VS Code command and select the desired
task.

### How can I add my own VS Code tasks?

Add your own tasks to the [tasks configuration file](.vscode/tasks.json). See the existing tasks
as examples.
