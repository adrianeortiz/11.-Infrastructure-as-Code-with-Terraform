### This project is for the Devops Bootcamp Exercise for "Infrastructure as Code with Terraform" 

#### IMPORTANT - please read the following:

Since K8s version 1.23 an additional driver is required to provision K8s storage in AWS. K8s volumes attach to cloud platform's storage - for AWS this means they attach to EBS volumes. The EBS CSI driver is responsible for handling EBS storage tasks and is not installed by default so without the installation of this driver, K8s volumes cannot be attached to storage in AWS. 

The node groups in this project are responsible for creating and attaching these volumes, so for this reason, as well as needing the driver to be installed we need to add a permissions policy to the node group so it can request these changes successfully through AWS - this is defined in a dedicated IAM role.

The following two lines must be added to your EKS Terraform file to ensure persistent storage using EBS CSI driver is installed and the node group permissions are configured correctly:

```sh
# 1. Including the add-on as part of EKS module:

cluster_addons = {
    aws-ebs-csi-driver = {most_recent = true}
}

# 2. Adding associated permissions as part of node group configuration:

iam_role_additional_policies = {
    AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
```

**Versions:**
- Terraform: v1.6.1
- eks module: 19.20.0
- vpc module: 5.2.0
- helm provider: v2.11.0 
- aws provider: v5.26.0
- kubernetes provider: v2.23.0
- ebs csi driver: v1.25.0

**Create S3 bucket:** 
- name: "my-bucket-exercise"
- region: eu-central-1

**Set variables:**
- env_prefix = "dev"
- k8s_version = "1.28"
- cluster_name = "my-cluster"
- region = "eu-central-1"

To execute the TF script:
```
terraform init

terraform apply -var-file="dev.tfvars"
```