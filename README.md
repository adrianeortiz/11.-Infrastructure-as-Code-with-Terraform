#### This project is for the Devops Bootcamp Exercise for:
#### "Infrastructure as Code with Terraform " 

### IMPORTANT - please read the following:

The following two lines must be added to your EKS Terraform file to ensure storage is configured correctly:

1. As part of EKS module:

`cluster_addons = {aws-ebs-csi-driver = {most_recent = true}}`

2. As part of node group configuration:
`iam_role_additional_policies = {AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"}` 

**Versions:**
- Terraform: v1.6.1
- eks module: 19.20.0
- vpc module: 5.2.0
- helm provider: v2.11.0 
- aws provider: v5.26.0
- kubernetes provider: v2.23.0
- ebs_csi_controller_role: v5.3.0

**Create S3 bucket:** 
- name: "my-bucket-exercise"
- region: eu-central-1

**Set variables:**
- env_prefix = "dev"
- k8s_version = "1.28"
- cluster_name = "my-cluster"
- region = "eu-central-1"

**To execute the TF script:**
    `terraform init`
    `terraform apply -var-file="dev.tfvars"`