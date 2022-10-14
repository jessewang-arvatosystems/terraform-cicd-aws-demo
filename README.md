# Terraform AWS CI-CD Demo

Based on [ci-cd-aws-developer-tools-tf](https://github.com/raktim00/ci-cd-aws-developer-tools-tf) 

Idea is to provision a CI-CD pipeline in AWS using Terraform.
The repository **infra-vpc-repo** in Code Commit will handle future Terraform provisioning.
Any code committed in the **infra-vpc-repo**'s **master** branch will trigger the CI-CD pipeline to validate, plan and apply the Terraform build.
This example will use Terraform to create a VPC and subnet.
The Terraform **terraform.tfstate** file will be stored in the S3 bucket **infra-vpc-backend/terraform_backend**

**AWS Technologies used:**
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
- An AWS account that can push to Code Commit
  - Open AWS UI go to IAM
  - Select the user
  - Click on the **Security credentials** tab
  - Scroll down and in the **HTTPS Git credentials for AWS Code Commit** click on the **Generate credentials** button
  - A popup will open, save this information for later use

## Quick Start
1. Open the Terminal and navigate to this repo's main directory
2. Initialize Terraform: `terraform init`
3. Build resources: `terraform apply --auto-approve`
4. Clone the repository: `git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/infra-vpc-repo` using the credentials generated previously in the Requirements section
   - If you receive a 403 error, the git credentials may have already been saved on your machine. Delete the existing 
   key (for example, Keychain Access for macOS), a credential manager utility for your version of Git (for example, 
   the Git Credential Manager included in Git for Windows), your IDE, or Git itself
5. Copy contents of example folder into the repo: `cp infra-vpc-repo-example/* infra-vpc-repo`
6. Navigate to the **infra-vpc-repo**: `cd infra-vpc-repo`
7. Add the files: `git add *`
8. Commit the files `git commit -m "Initial commit"`
9. Push the files `git push`
10. Open the AWS UI to verify the following changes
    - In S3, verify that **terraform.tfstate** exists in the S3 bucket: **infra-vpc-backend/terraform_backend**
    - In VPC, verify that a new VPC has been created with tag key: **Creator** and value: **terraform example**
    - While in the VPC dashboard, open subnets and verify a new Subnet has been created with tag key: **Creator** and value: **terraform example**
11. You're done! Changes pushed to the **infra-vpc-repo**'s **master** branch will trigger the pipeline and the AWS resources will be provisioned accordingly

## Destroying the infrastructure
There probably is a more elegant way to do this, but this should suffice given how rarely you will need to destroy the entire Terraform infrastructure
1. Open AWS UI and go to CodeBuild
2. Look for **infra-vpc-codebuild-project-destroy** and click on it
3. Click on the **Start build with overrides** button
4. Click on the **Advance build overrides** button
5. Change the Source to **AWS CodeCommit**, select **infra-vpc-repo** and choose branch **master**
6. In the Environment section, check the **Allow AWS CodeBuild to modify this service role so it can be used with this build project** checkbox
7. Scroll all the way down and click **Start build**
8. Once the build completes, the Terraform infrastructure will be destroyed, you can validate this by inspecting the absence of the VPC and subnet
