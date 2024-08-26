output "flow_arn" {
  description = "Flow's ARN"
  value       = aws_appflow_flow.appflow.arn
}

output "flow_status" {
  description = "The current status of the flow"
  value       = aws_appflow_flow.appflow.flow_status
}

output "flow_tags" {
  description = "Map of tags assigned to the resource"
  value       = aws_appflow_flow.appflow.tags_all
}
