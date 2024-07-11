# my-devops-training

move prod blocaks to bottom
add missed tasks
use terraform format to fix the identation
learn about how to write README 
add README file for both repos

# AWS EC2 Instance Deployment with Terraform

This project demonstrates how to use Terraform to deploy an AWS EC2 instance running a simple deployment script. The script installs dependencies, clones a repository, and runs a Go application.

## Prerequisites

Before you begin, ensure you have the following installed locally:

-   Terraform
-   AWS CLI configured with appropriate credentials

## Getting Started

### Clone the Repository

     ```bash

      `git clone https://github.com/BNeerajKrishna/my-terraform-session.git

### Move to directory      
      
       cd my-terraform-session

### Set Up AWS Key Pair

Ensure you have an SSH key pair (`mykey.pub` and `mykey`) in the root directory of the project. Adjust the `aws_key_pair.deployer.public_key` path in `main.tf` if needed.

### Configure Terraform

Modify `variables.tf` as needed, particularly `instance_count`, `vm_types`, `public_ip_enable`, `subnet_id`, and `availability_zone` based on your AWS setup.

### Deploy the EC2 Instance

    ```bash

    `terraform init`

    `terraform apply'

## Accessing the Application

Once Terraform has successfully deployed the instance:

1.  SSH into the instance using the public IP address:
    
    ```bash
    
    `ssh -i ./mykey ubuntu@<instance_public_ip>` 
    
2.  Navigate to the `/home/ubuntu/go-user.log` file to monitor the deployment script's progress and logs.
    
3.  Access your application deployed on the instance by visiting `http://<instance_public_ip>:5000` in a web browser.
    

## Cleaning Up

After you're done testing, tear down the resources to avoid unnecessary charges:

    ```bash

    `terraform destroy` 

## Directory Structure

-   `main.tf`: Terraform configuration file defining AWS resources and provisioning scripts.
-   `variables.tf`: Variables used in the Terraform configuration (e.g., instance count, instance types).
-   `scripts/nginx.sh`: Example deployment script copied to the instance and executed.
-   `mykey.pub``: SSH key pair used to access the instance.

## Notes

-   The instance runs an Ubuntu AMI (specified in `data.aws_ami.ubuntu`).
-   Security groups allow inbound SSH (port 22), HTTP (port 80), and custom application port (port 5000).
-   Adjust security group settings (`aws_security_group.ssh_access`) as per your security requirements.

## To learn

- AWS
- terraform
- git
- linux command
- shell script
- ssh keys
- ansible
- docker
- github actions
- python/go
- kubernetes


