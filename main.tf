module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"

  public_subnets = [
    {
      cidr = "10.0.1.0/24"
      az   = "ap-south-1a"
    },
    {
      cidr = "10.0.2.0/24"
      az   = "ap-south-1b"
    }
  ]
}

module "sg" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source    = "./modules/ec2"
  ami       = "ami-0f559c3642608c138"
  subnet_id = module.vpc.subnet_ids[0]
  sg_id     = module.sg.sg_id
}

resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = "arn:aws:iam::588376707040:user/awsfree"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_policy" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_eks_access_entry.admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}