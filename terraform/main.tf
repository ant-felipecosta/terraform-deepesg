terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  #access_key = var.aws_access_key
  #secret_key = var.aws_secret_key
  region = "us-east-1"
}


module "vpc-main" {
  source = "./modules/vpc"

  vpc_name = "VPC-PROD"
  cidr     = "10.170.0.0/16"
  ambiente = "PROD"
}

module "ecs-cluster" {
  source = "./modules/fargate"
    private-subnets = module.vpc-main.subnets_private
  public-subnets  = module.vpc-main.subnets_public
  vpc-id          = module.vpc-main.vpc_id

  
  cluster-name    = "clusterdeepesg"

  albname = "ALB-DEEPESG"

}