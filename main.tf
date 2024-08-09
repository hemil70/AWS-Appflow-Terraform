resource "aws_s3_bucket" "appflow_bucket" {
  bucket        = "dest-bucket-appflow"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "appflow_bucket_policy" {
  bucket = aws_s3_bucket.appflow_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "appflow.amazonaws.com"
        }
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:PutObjectAcl"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.appflow_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.appflow_bucket.bucket}/*"
        ]
      }
    ]
  })
}

module "github" {
  source = "./github"

  connector_profile_name      = var.connector_profile_name
  connection_mode             = var.connection_mode
  connector_label             = var.connector_label
  connector_type              = var.connector_type
  authentication              = var.authentication
  properties                  = var.properties
  flow_name                   = var.flow_name
  api_version                 = var.api_version
  source_connector_properties = var.source_connector_properties
  destination_bucket_name     = aws_s3_bucket.appflow_bucket.bucket
  destination_connector_type  = var.destination_connector_type
  task                        = var.task
  trigger_type                = var.trigger_type
  trigger_properties          = var.trigger_properties

}
