## GIT
1. What is Git?
Git is a free and open source distributed version control system which enables you to store code, track revision history, merge code changes, and revert to earlier code version when needed.

2. What is Version Control System?
➤Version Control System is a collection of software tools that help a team to work together on the same project and allow them to manage changes to a file or set of data over time

➤It maintains all the edits and historic versions of the project.

3. What is a Git repository?
Git repository is a place where all the Git files are stored.
These files can either be stored on the local repository or on the remote repository.
It allows us to save versions of our code which we can access whenever needed.

4. What are the states of a file in Git?

Three different states.

Modified

Staged

Committed

5. What does git clone do?

Git clone allows you to create a local copy of the remote GitHub repository

6. why git is a distributed version control system?

Git is considered a distributed version control system because it allows every user to have a complete copy of the entire repository history on their local machine. This is different from centralized version control systems, where the repository is stored on a single central server and users check out a working copy from that central repository.

7. mention the various git repository hosting services?

GitHub
GitLab
Bitbucket
SourceForge
GitKraken
Gogs
AWS CodeCommit

8. difference between git pull and git fetch

git pull performs a git fetch followed by a git merge (or git rebase, if configured). It updates your local branch with changes from the corresponding remote branch and integrates those changes into your working directory.

git fetch downloads changes from a remote repository but does not integrate those changes into your working directory. It updates your remote-tracking branches with the latest commits from the remote repository.

9. difference between git merge and git rebase

git merge integrates changes from one branch into another by creating a new commit that combines the histories of both branches.

git rebase integrates changes from one branch onto another by applying commits from the source branch on top of the target branch, effectively rewriting the commit history.

10. Advantages of using git

Distributed Version Control: Every user has a full copy of the repository, ensuring offline work and data redundancy.

Branching and Merging: Efficiently creates and manages branches, and integrates changes with smooth merging.

History and Rollback: Maintains detailed commit history and provides tools to revert changes.

Open Source: Free to use with available source code and a supportive community.

Large Ecosystem: Extensive tools and integrations available through platforms like GitHub and GitLab.

Resilience: Every local repository acts as a backup, making it fault-tolerant.

11. What is Git stash ?

GIT stash captures the present state of the working directory and index it and keeps it on the stack at a later stage. 
It returns a clean working directory.

12. What does the git reset --mixed and git merge --abort commands do?

git reset --mixed is used to undo changes made in the working directory and staging area.

Git merge --abort is used to stop the merge process and return back to the state before the merging began.

13. What is the difference between fork, branch, and clone?

A fork is a copy of a repository that you manage. Forks let you make changes to a project without affecting the original repository.

In Git, a branch is a new/separate version of the main repository

git cloning means pointing to an existing repository and make a copy of that repository in a new directory, at some other location.

14. What is the functionality of git clean command?

The git clean command removes the untracked files from the working directory.


## TERRAFORM

1. What is Terraform?
 Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp that allows you to define and provision infrastructure using a high-level configuration language known as HashiCorp Configuration Language (HCL).

2. What are the main features of Terraform?
 Key features of Terraform include Infrastructure as Code, multi-cloud support, state management, dependency management, and modularity.

3. What is Infrastructure as Code (IaC)?
 Infrastructure as Code is a practice where infrastructure is managed and provisioned using code and configuration files, allowing for automated and consistent deployment.

4. What is the purpose of the terraform init command?
 The terraform init command initializes a Terraform configuration directory, downloading necessary provider plugins and setting up the local working environment.

5. Explain the terraform plan command.
 The terraform plan command creates an execution plan that shows the changes Terraform will make to the infrastructure based on the current configuration and state.

6. What is a Terraform provider?
 A provider in Terraform is a plugin responsible for managing resources for a specific cloud service or platform, such as AWS, Azure, or Google Cloud.

7. What is the purpose of the terraform apply command?
 The terraform apply command applies the changes required to reach the desired state defined in the configuration files, creating or updating resources as needed.

8. What is a Terraform module?
 A Terraform module is a container for multiple resources that are used together. Modules allow you to create reusable and organized components for your infrastructure. For example, you might create a module to manage a web server and its associated resources, which can then be reused across different environments or projects.

9. What is the terraform state file?
 The terraform state file maintains the current state of the infrastructure managed by Terraform, tracking the resources and their metadata.

10. What is a resource in Terraform?
A resource is a basic component in Terraform that represents a single piece of infrastructure, such as an EC2 instance or a storage bucket.

11. What is the purpose of variables in Terraform, and how are they used?
Variables in Terraform allow you to parameterize your configuration files. They enable you to reuse and customize configurations without hardcoding values. Variables can be defined in .tf files, passed via command-line arguments, or set in environment files. 

12. What are some best practices for managing Terraform configurations?

Use modules: Break down configurations into reusable and manageable modules.
Version control: Store Terraform configurations and state files in version control systems like Git.
Remote state: Use remote backends (e.g., S3 with locking) to store state files securely and collaboratively.
Environment separation: Use workspaces or separate configurations for different environments (e.g., dev, staging, production).
Consistent naming: Follow consistent naming conventions for resources and variables.
Plan and review: Always use terraform plan to review changes before applying them.

## Blocks

1. Provider Block
Defines the provider(s) that Terraform will use to manage resources. Providers are responsible for interacting with external APIs.

provider "aws" {
  region = "us-east-1"
}


2. Resource Block
Defines a single piece of infrastructure, such as a virtual machine, database, or network. Each resource block specifies the type of resource and its configuration.

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}

3. Data Block
Used to retrieve information from an external source. Data blocks are read-only and don't manage infrastructure but can be used to reference data that other resources might need.

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]
}

4. Variable Block
Defines input variables that can be used to parameterize the configuration. Variables allow for more flexible and reusable configurations.

variable "instance_type" {
  description = "The type of instance to create"
  default     = "t2.micro"
}

5. Output Block
Defines outputs that are returned after Terraform applies the configuration. Outputs can be used to expose information about your resources.

output "instance_id" {
  value = aws_instance.example.id
}

6. Module Block
Invokes a module, which is a container for multiple resources that are used together. Modules help in organizing and reusing configurations.

module "vpc" {
  source = "./modules/vpc"
  cidr   = "10.0.0.0/16"
}

7. Backend Block
Defines where Terraform stores its state file. This is useful for remote state storage and collaboration.

terraform {
  backend "s3" {
    bucket         = "my-tf-state"
    key            = "terraform/state"
    region         = "us-east-1"
  }
}

8. Locals Block
Defines local values that can be used within the configuration. They are useful for defining reusable values.

locals {
  instance_type = "t2.micro"
}

## ANSIBLE

1. What is Ansible?
Ansible is an open-source automation tool used for configuration management, application deployment, and task automation. It uses a declarative language to describe system configurations and relies on SSH (for Linux/Unix) or WinRM (for Windows) to communicate with managed nodes. Ansible operates in a push-based model, where the control node pushes configurations to the target nodes.

2. Explain the architecture of Ansible.
Ansible's architecture consists of:

Control Node: The machine where Ansible is installed and from which commands are executed. This node manages the communication and automation tasks.

Managed Nodes: The systems that Ansible configures and manages. These nodes are targeted by playbooks and roles.

Inventory: A file or dynamic source that lists the managed nodes and their details. It can be in INI, YAML, or JSON format.

Modules: Reusable scripts or functions that Ansible uses to perform specific tasks (e.g., installing packages, managing services).

Playbooks: YAML files that define a set of tasks to be executed on managed nodes. Playbooks describe the desired state of the system.

Roles: A way to group tasks, handlers, and variables into reusable units. Roles help in organizing and reusing configurations.

3. What is an Ansible playbook?
An Ansible playbook is a YAML file that contains a list of plays. Each play defines a set of tasks to be executed on one or more hosts. Playbooks are used to describe the desired state of the system and automate configuration, deployment, and orchestration tasks.

4. What is an inventory file in Ansible?
An inventory file is a configuration file that lists the hosts or nodes that Ansible will manage. It can be a static file in INI or YAML format or a dynamic inventory script. The inventory file groups hosts and provides details needed for Ansible to connect to and manage them.

5. What is a role in Ansible?
A role in Ansible is a structured way to organize and reuse configuration tasks, handlers, variables, and templates. Roles encapsulate related tasks and can be used across multiple playbooks. A role typically has a specific directory structure, including folders for tasks, handlers, defaults, and templates.

6. How do you define variables in Ansible?
Variables in Ansible can be defined in several places:

Playbooks: Directly within playbooks or tasks.
Inventory files: For host-specific or group-specific variables.
Vars files: Separate YAML files included in playbooks or roles.
Ansible Vault: For encrypting sensitive data.

7. What is the difference between command and shell modules in Ansible?

command Module: Executes a command on the remote node but does not process the command through a shell. It is used for running commands that do not require shell features such as redirection or piping.

shell Module: Executes a command through a shell, allowing the use of shell features like redirection, pipes, and environment variable expansion.

8. What are handlers in Ansible?
Handlers are special tasks in Ansible that are triggered by other tasks. They are typically used for tasks that need to be executed only when there is a change, such as restarting a service after a configuration change. Handlers are defined similarly to regular tasks but are listed under the handlers section of a playbook or role.

9. How do you include files in Ansible playbooks?
Files can be included in Ansible playbooks using include or import statements. This allows for modularizing and reusing playbook content.

'include': Used to include another playbook or tasks file. It’s processed at runtime.

'import': Used to include other playbooks, tasks, or roles at playbook parsing time.

10. What is Ansible Vault?
Ansible Vault is a feature that allows you to encrypt sensitive data, such as passwords or API keys, within Ansible files. It ensures that sensitive information is kept secure while still being accessible to playbooks. You can encrypt files, variables, or secrets with Ansible Vault and decrypt them when needed.


## DOCKER

1. What is Docker?
Docker is an open-source platform that automates the deployment, scaling, and management of applications using containerization technology. Containers package an application and its dependencies into a single, portable unit, ensuring that it runs consistently across different environments. Docker provides tools to create, deploy, and manage these containers efficiently.

2. What is a Docker container?
A Docker container is a lightweight, standalone, and executable package that includes everything needed to run a piece of software: the code, runtime, system tools, libraries, and settings. Containers are isolated from each other and the host system, ensuring consistency and portability across different environments.

3. What is the difference between Docker containers and virtual machines?

Docker Containers: Share the host OS kernel and run as isolated processes. They are lightweight, start quickly, and use fewer resources compared to VMs.
Virtual Machines: Run a full OS instance along with the application. VMs are heavier, take longer to start, and require more resources as each VM includes a full OS.

4. What is a Docker image?
A Docker image is a read-only template that contains the application code, runtime environment, libraries, and dependencies required to run an application. Images are used to create Docker containers. They are built using a Dockerfile and can be shared through Docker registries like Docker Hub.

5. What is a Dockerfile?

A Dockerfile is a text file that contains a series of instructions to build a Docker image. It specifies the base image, copies files, installs dependencies, and configures the environment. Docker uses this file to create a consistent and reproducible image.

6. What are Docker volumes?

Docker volumes are used to persist data generated and used by Docker containers. Unlike the container's filesystem, which is ephemeral, volumes are stored on the host filesystem and can be shared between containers. They ensure data persistence across container restarts and re-creations.

7. What is Docker Hub?

Docker Hub is a cloud-based Docker registry service where you can find and share Docker images. It provides a centralized repository for storing and distributing Docker images and includes both public and private repositories.

8. What are Docker networks?

Docker networks enable communication between containers and between containers and the outside world. Docker supports several types of networks, such as:

Bridge: The default network type for containers on a single host.
Host: Uses the host’s network stack, bypassing network isolation.
Overlay: Used for multi-host networking in Docker Swarm.
None: Disables networking for the container.

9. What is the purpose of the docker exec command?

The docker exec command is used to run commands inside a running Docker container. This is useful for debugging or interacting with the container’s environment.

10. What is a Docker registry?

A Docker registry is a storage and distribution system for Docker images. It allows you to store, retrieve, and share images. Docker Hub is a public registry, but you can also set up private registries or use other services like Docker Trusted Registry.

