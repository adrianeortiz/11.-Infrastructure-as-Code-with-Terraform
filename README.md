Versions:
- Terraform: v1.6.1
- eks module: 19.20.0
- vpc module: 5.2.0
- helm provider: v2.11.0 
- aws provider: v5.26.0
- kubernetes provider: v2.23.0
- ebs_csi_controller_role: v5.3.0

Create S3 bucket: 
- name: "my-bucket-exercise"
- region: eu-central-1

Set variables:
- env_prefix = "dev"
- k8s_version = "1.28"
- cluster_name = "my-cluster"
- region = "eu-central-1"

To execute the TF script:
    `terraform init`
    `terraform apply -var-file="dev.tfvars"`