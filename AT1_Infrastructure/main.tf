module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.8.1"

    name = "infoline-vpc"
    cidr = "10.0.0.0/16"
    
    azs = ["eu-west-3a", "eu-west-3b"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets  = ["10.0.4.0/24", "10.0.5.0/24"]
    single_nat_gateway = true # A désactiver en production
    enable_nat_gateway = true 
    enable_dns_hostnames = true

    public_subnet_tags = {
        "kubernetes.io/role/elb" = 1
    }

    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = 1
    }
}

module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "20.8.5"

    cluster_name = "infoline-eks-cluster"
    cluster_version = "1.34"
    cluster_endpoint_public_access = true
    enable_cluster_creator_admin_permissions = true # A désactiver en production

    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    eks_managed_node_groups = {
        main = {
            name = "main-node-group"
            instance_types = ["t3.large"] # Modèle avec 8GB RAM (Elasticsearch + Kibana)
            min_size     = 1
            max_size     = 2
            desired_size = 1
        }
    }
}