output "sonarqube_id" {
  description = "ID of SonarQube instance"
  value       = aws_instance.sonarqube.id
}

output "sonarqube_public_ip" {
  description = "Public IP of SonarQube instance"
  value       = aws_instance.sonarqube.public_ip
}

output "sonarqube_private_ip" {
  description = "Private IP of SonarQube instance"
  value       = aws_instance.sonarqube.private_ip
}

output "nexus_id" {
  description = "ID of Nexus instance"
  value       = aws_instance.nexus.id
}

output "nexus_public_ip" {
  description = "Public IP of Nexus instance"
  value       = aws_instance.nexus.public_ip
}

output "nexus_private_ip" {
  description = "Private IP of Nexus instance"
  value       = aws_instance.nexus.private_ip
}

output "jenkins_id" {
  value = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}
