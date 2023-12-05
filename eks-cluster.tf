data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20.0"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.28"
  cluster_endpoint_public_access = true

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id
  tags = {
    environment = "bootcamp"
  }

  enable_irsa = true

  cluster_addons = {
    # starting from EKS 1.23 CSI plugin is needed for volume provisioning.
    aws-ebs-csi-driver = { most_recent = true }
  } 

  # worker nodes
  eks_managed_node_groups = {
    nodegroup = {
      use_custom_templates = false
      instance_types       = ["t3.small"]
      node_group_name      = var.env_prefix

      min_size     = 1
      max_size     = 3
      desired_size = 1

      tags = {
        Name = "${var.env_prefix}"
      }   
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }  
    }
  }
  fargate_profiles = {
    profile = {
      name = "my-fargate-profile"
      selectors = [
        {
          namespace = "my-app"
        }
      ]
    }
  }
}

  