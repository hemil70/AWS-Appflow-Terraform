output "arn" {
  description = "ARN of the connector profile"
  value       = aws_appflow_connector_profile.connector_profile.arn
}

output "credentials_arn" {
  description = "ARN of the connector profile credentials"
  value       = aws_appflow_connector_profile.connector_profile.credentials_arn
}