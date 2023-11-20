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
      coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    vpc-cni = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    } 
    # starting from EKS 1.23 CSI plugin is needed for volume provisioning.
    aws-ebs-csi-driver = {
      service_account_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_name}-ebs-csi-controller"
      resolve_conflicts_on_create = "OVERWRITE"
    }
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