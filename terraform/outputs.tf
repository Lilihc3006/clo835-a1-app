output "ec2_public_ip" {
  value       = aws_instance.webserver.public_ip
  description = "Public IP of the EC2 instance"
}

output "ecr_webapp_repo_url" {
  value       = aws_ecr_repository.webapp_repo.repository_url
  description = "ECR repo URL for the webapp image"
}

output "ecr_mysql_repo_url" {
  value       = aws_ecr_repository.mysql_repo.repository_url
  description = "ECR repo URL for the MySQL image"
}
