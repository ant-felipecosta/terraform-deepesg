variable "cidr" {
  type        = string
  description = "valor do CIDR BLOCK"
}

variable "vpc_name" {
  type        = string
  description = "Nome na VPC"
}

variable "ambiente" {
  type        = string
  description = "Tipo de Ambiente(PROD, DEV ou TESTE)"

}

