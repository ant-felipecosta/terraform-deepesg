variable "cluster-name" {
  type        = string
  description = "Nome da Cluster"

}

variable "albname" {
  type = string
}

variable "private-subnets" {
  type = list(string)
}

variable "public-subnets" {
  type = list(string)
}

variable "vpc-id" {
  type = string
}

variable "docker_image_app1" {
  description = "Docker image for app1"
  type        = string
}

variable "docker_image_app2" {
  description = "Docker image for app2"
  type        = string
}
