# Capstone project for AWS badge
### Initial setup forked from https://github.com/Axel-ITT/learn-terraform


## Start the Server

Terraform needs to be installed

copy the AWS CLI credentials file into this folder: .aws/
```
terraform init
terraform plan -out "plan.out" -var-file "config.tfvars"
terraform apply --auto-approve -var-file "config.tfvars"

//To clean up the infrastructure:
terraform destroy --auto-approve -var-file "config.tfvars"
```

## Configuration

Following variables need to be set in config.tfvars:
```
project = "string"
environment = "string"

# exapmle value:
instance_type = "t3.nano"
 
# exapmle value:
AZ-List = ["us-west-2a", "us-west-2b"]

# exapmle value:
setup_filepath = "user-data/nodered-setup.sh"

# exapmle value:
ssh_address_range = "99.99.99.99/32"

# Name of your private key file
key_path = "string"
ami_id = "string"
```

## Keyfiles / EC2 Deployment

Keyfiles folder requires the private key file for your EC2 instances

## Deploy new flows

Terraform is set to deploy individual flows for every AZ from "node-red/{count.index}/flows.json"

## Node-red has been set to disable editor for PROD
settings.js
```
    httpAdminRoot: false,
    disableEditor: true,
```