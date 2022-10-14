# Terraform AWS CI-CD Demo

Based on [ci-cd-aws-developer-tools-tf](https://github.com/raktim00/ci-cd-aws-developer-tools-tf) 

Idea is to provision a CI-CD pipeline in AWS using Terraform.
The repository "infra-vpc-repo" in Code Commit will handle future Terraform provisioning.
Any code committed in the "infra-vpc-repo" master branch will trigger the CI-CD pipeline to validate, plan and apply the Terraform build.
The Terraform .tfstate file will be stored in an S3 bucket `infra-vpc-backend/terraform_backend`

AWS Technologies used:
- Code Commit
- Code Pipeline
- Code Deploy
- CloudWatch
- VPC
- S3

## Requirements
- Terraform CLI
- AWS CLI 
- An AWS account that has admin access
- Configure an AWS account that can push to Code Commit
  - In the AWS UI interface go to IAM
  - Select the user
  - Click on the "Security credentials" tab
  - Scroll down and in the "HTTPS Git credentials for AWS Code Commit" click on the "Generate credentials" button
  - A popup will open, save this information for later use

## Quick Start
1. Open Terminal and navigate to the main directory
2. Initialize Terraform: `terraform init`
3. Build resources: `terraform apply --auto-approve`
4. Clone the repository: `git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/infra-vpc-repo`
   - If you receive a 403 error, the git credentials may have already been saved on your machine. Delete the existing 
   key (for example, Keychain Access for macOS), a credential manager utility for your version of Git (for example, 
   the Git Credential Manager included in Git for Windows), your IDE, or Git itself.
5. Copy contents of example folder into the repo: `cp infra-vpc-repo-example/* infra-vpc-repo`
6. Navigate to the "infra-vpc-repo": `cd infra-vpc-repo`
7. Add the files: `git add *`
8. Commit the files `git commit -m "first terraform commit"`
9. Push the files `git push`
10. Open the AWS UI interface to verify the following changes
    - In S3, verify that `terraform.tfstate` exists in the S3 bucket `infra-vpc-backend/terraform_backend`
    - In VPC, verify that a new VPC has been created with tag key: "Creator and value: "terraform example"
    - While in the VPC dashboard, open subnets and verify a new Subnet has been created with tag key: "Creator and value: "terraform example"
