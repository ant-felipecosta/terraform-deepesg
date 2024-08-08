output "subnets_private" {
  description = "IDs das sub-redes privadas"
  value       = [aws_subnet.subnet-private-a.id, aws_subnet.subnet-private-b.id]
}

output "subnets_public" {
  description = "IDs das sub-redes públicas"
  value       = [aws_subnet.subnet-public-a.id, aws_subnet.subnet-public-b.id]
}

output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}
