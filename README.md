Terraform
===========

=> A software Developed by Hashicorp

=> To create/provision infrastructure in cloud platforms.

=> IAC software (infrastructure as code)

=> Supports all most all cloud platforms.

=> Terraform will use HCL language to create infrastructure in cloud.

		HCL : Hashicorp configuration language

=> Terraform we can install in multiple operating systems

	Ex: Windows, Linux

======================================
Terraform Setup in Windows Machine	
======================================

Step-1 : Download terraform s/w as a zip file from official website

		Note: We can see "terraform.exe" file


Step-2 : Set path for terraform s/w in our system env variables.


Step-3 : Verify terraform setup using cmd

		$ terraform -v

Step-4 : Download and install VS Code IDE to write terraform scripts	

		URL : https://code.visualstudio.com/download			

========================
Terraform Architecture
========================

=> Terraform will use HCL scripts to provision infrastructure in cloud.

=> We need to write HCL script and save it in .tf file

	
	.tf file ==> init ==> fmt => validate => plan => apply ==> destroy


=> We will use below commands to work with terraform scripts	

## terraform init : Intialize terraform script (download provider related plugins)

## terraform fmt : format terraform script file indent spaces (optional)

## terraform validate : Verify terraform syntax is correct or not (optional)

## terraform plan : Creates Execution plan of our script (optional)

## terraform apply : Execute script and create resources

Note: tfstate file will be created to track the resources created with the script.

## terraform destroy : It is used to delete the resources created with our script.

### Terraform AWS Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs

======================
Create EC2 Instance
======================

1) Create IAM user and Generate Access keys

2) Write Terraform script file like below 

```
provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA2RP62WEB4UT"
  secret_key = "cWIc0cL3casSQWDs+o+3BpYvDwVNx8z"
}

resource "aws_instance" "ait_vm_1" {
  ami             = "ami-0b32d400456908bf9"
  instance_type   = "t2.micro"
  key_name        = "ashokitnew"
  security_groups = ["default"]

  tags = {
    Name = "LinuxVM"
  }
}
```

3) Execute Terraform commands

$ terraform init
$ terraform fmt
$ terraform validate
$ terraform plan
$ terraform apply --auto-approve
$ terraform destory --auto-approve

===========
Assignment
===========

1) Create 2 EC2 Vms using 2 terraform script with count attribute and assign unique name for each instance.

2) Create S3 bucket using terraform

3) Create RDS instance using terraform


=========================
Variables in Terraform
=========================

=> Variables are used to store data in key-value format

      id = 101

      name = ashokit

=> We can remove hard coded values from "resource blocks" using variables

=> Variables we can maintain in seperate .tf file

    ex : inputs.tf
         outputs.tf

=> We have 2 types of variables in terraform

    1) Input variables

    2) Output Variables

=> Input variables are used to supply values to the terraform script for execution.

    Ex: ami, instance_type, keyname, security_group

=> Output variables are used to get the values from terraform script after execution.

    Ex-1 : After EC2 VM creation, print ec2-vm public ip

    Ex-2 : After S3 bucket got created, print bucket info

    Ex-3 : After RDS instance got created, print DB endpoint

    Ex-4 : After IAM user got created print IAM user info


=========== provider.tf ==========

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA2RP6H2WEB4UT"
  secret_key = "cWIc0cx4hMjDJQpQWDs+BpYvDwVNx8z"
}

=========== input-vars.tf ==========

variable "ami" {
  description = "Amazon machine image id"
  default     = "ami-0b32d400456908bf9"
}

variable "instance_type" {
  description = "Represens EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "key pair name"
  default     = "ashokitnew"
}

============ main.tf =============

resource "aws_instance" "ait_vm_1" {
  ami   = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = ["default"]

  tags = {
    Name = "LinuxVM"
  }
}

=========== output-vars.tf =============

output "public_ip" {
  value = aws_instance.ait_vm_1.public_ip
}

output "private_ip" {
  value = aws_instance.ait_vm_1.private_ip
}

output "ec2_full_info" {
  value = aws_instance.ait_vm_1
}
=========================================

===================
Terraform Modules
===================

=> A Terraform module is a set of terraform configuration files available in a single directory. 

=> One module can contain one or more .tf files like below

        01-Project
          - provider.tf
          - input-vars.tf
          - main.tf
          - output-vars.tf

Ex: inside project directory we can take ec2, s3, rds, EKS as child modules.

        SBI_Project
           - provider.tf
           - main.tf
           - outputs.tf
           - modules
             - EC2
                -inputs.tf
                -main.tf
                -outputs.tf
             - S3
                -inputs.tf
                -main.tf
                -outputs.tf
             - RDS
                -inputs.tf
                -main.tf
                -outputs.tf


Note : Using terraform modules we can achieve readability & re-usability also.

Note: We will run terraform commands from root module and root module will invoke child modules for execution.

======================================
Terraform project setup with Modules
======================================

## Step-1 :: Create Project Directory in VS CODE IDE

        Ex: 01-SBI

## Step-2 :: Create modules directory inside project directory  

        Ex: 01-SBI
              - modules     

## Step-3 :: Create EC2 and S3 directories inside "modules" directory.

        Ex: 01-SBI
              - modules
                  - ec2

                  - s3

## Step-4 :: Create below files inside "ec2" directory and write HCL script

                inputs.tf
                main.tf
                outputs.tf


## Step-5 :: Create below files inside "s3" directory and write HCL script

                inputs.tf
                main.tf
                outputs.tf


## Step-6 :: Create provider.tf file in root module (project folder)

## Step-7 :: create "main.tf" file in root module and invoke child modules from root module like below.

              module "my_ec2"{
                  source = "./modules/ec2"
              }

              module "my_s3" {
                  source = "./modules/s3"
              }

### Step-8 :: Create "ouputs.tf" in project root module and access child modules related outputs.

          output "vm_public_ip"{
                value = "module.{module_name}.{op_Var_name}"
          }

          output "s3_bucket_info"{
              value = "module.{module_name}.{op_Var_name}"
          }

### Step-9 :: Execute terraform commands from root module.          

============================
Environments of the project
============================

=> Env means the platform that is required to run our applications.

    Ex: Servers (Vms), Database, Storage, Network, Security, Monitoring..

=> One project contains multiple envs in real-time

      Ex: DEV, SIT or QA, UAT, PILOT, PROD

Dev Env :  Developers will use it for code integration testing

SIT / QA Env : Testers will use it for System Integration Testing

UAT Env: Client will use it for Acceptance testing.

Pilot Env : Pre-Prod testing and Performance testing.

Prod Env : Live Environment.


=> We can categorize above environments into 2 types

    1) NON-PROD Envs ( Ex: DEV, SIT, UAT and PILOT)

    2) PROD Env

=> NON-PROD envs will be used with in the organization for testing purpose

=> PROD env will be used by end users (live traffic) (very important)    

Note: In real-time from environment to environment infrastructure resources configuration might be different

    Ex: 

      For NON-PROD : t2.medium instances required

      For PROD : t2.large instances required      

=> To achieve above requirements we need to maintain environment specific input variable files like below..

      inputs-dev.tf : Input variables for dev env infra setup

      inputs-qa.tf : Input variables for SIT env infra setup

      inputs-uat.tf : Input variables for UAT env infra setup

      inputs-pilot.tf : Input variables for PILOT env infra setup

      inputs-prod.tf : Input variables for PROD env infra setup

=> When we have multiple input variable files like above we need to specifiy from which file terraform apply command should pick data.

                
          # create infrastructure for DEV env
          $ terraform apply --var-file=inputs-dev.tf

          # create infrastructure for SIT env
          $ terraform apply --var-file=inputs-sit.tf


=========================
Workspace in terraform
========================= 

=> When we execute terraform script for DEV env it will geneate .tfstate file.

=> When we execute same terraform script for SIT env it will update existing resources only instead of creating new resources.

Note: But we need new resources to be created for SIT env without modifiy DEV env resources.

=> To Achieve above requirement we need to use Terraform Workspaces concept.

=> When we use workspace, it will maintain seperate state file for every environment/workspace.

Note: If we are able to seperate State Files based on env then we can execute same script for multiple environments and every time new resources will be created.

================================
Terraform workspace commands
================================

$ terraform workspace show

$ terraform workspace new dev

$ terraform workspace new sit

$ terraform workspace new uat

$ terraform workspace new prod

$ terraform workspace list

$ terraform workspace select dev

$ terraform workspace select sit


==================================
Working with terraform workspaces
==================================

Step-1: Create Terraform Project

Step-2: Create provider.tf file and configure provider details

Step-3: Create input variables files based on environments and initialize variable values.

  Ex:   

      dev.tfvars
      sit.tfvars
      uat.tfvars


``` dev.tfvars ```

ami = "ami-0b32d400456908bf9"

instance_type = "t2.micro"

key_name = "ashokitnew"

```` sit.tfvars ```

ami = "ami-0b32d400456908bf9"

instance_type = "t2.medium"

key_name = "ashokitnew"

```

Note: variables declration will happen in main.tf and variables intialization will happen in above files.      


Step-4 : Create main resource script file


```

variable "ami" {
}

variable "instance_type" {
}

variable "key_name" {
}

resource "aws_instance" "ait_vm_3" {
  ami   = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = ["default"]

  tags = {
    Name = "LinuxVM-3"
  }
}

```

Step-4 : Create output variable file

```
output "public_ip"{
    value = aws_instance.ait_vm_3.public_ip
}

output "private_ip"{
    value = aws_instance.ait_vm_3.private_ip
}
```

Step-7 : Create Workspaces from project root module

        $ terraform workspace new dev
        $ terraform workspace new sit

Step-8 : Select workspace

        $ terraform workspace select dev          

Step-9 : Run script and check state files

        # terraform init

        $ terraform apply --var-file=dev.tfvars           

Note: When we use workspaces concept, it will maintain seperate state file for every environment.


Step-9 : switch to sit workspace and run the script and verify statefile

        $ terraform workspace select sit

        $ terraform plan --var-file=sit.tfvars

        $ terraform apply --var-file=sit.tfvars

