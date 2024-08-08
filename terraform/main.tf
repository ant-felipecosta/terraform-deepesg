terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "terraform-backend-deepesg"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
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
  source            = "./modules/fargate"
  private-subnets   = module.vpc-main.subnets_private
  public-subnets    = module.vpc-main.subnets_public
  vpc-id            = module.vpc-main.vpc_id
  docker_image_app1 = "772767048757.dkr.ecr.us-east-1.amazonaws.com/app1"
  docker_image_app2 = "772767048757.dkr.ecr.us-east-1.amazonaws.com/app2"
  cluster-name      = "clusterdeepesg"

  albname = "ALB-DEEPESG"

}