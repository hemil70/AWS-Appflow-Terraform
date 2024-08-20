resource "aws_s3_bucket" "appflow_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.appflow_bucket.id
  policy = data.aws_iam_policy_document.appflow_s3_bucket_policy.json
}

data "aws_iam_policy_document" "appflow_s3_bucket_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["appflow.amazonaws.com"]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetBucketAcl",
      "s3:PutObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.appflow_bucket.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.appflow_bucket.bucket}/*"
    ]
  }
}

data "aws_secretsmanager_secret" "secret" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

module "github_connector_profile" {
  source = "./modules/connector_profile"

  connector_profile_name            = var.connector_profile.name
  connector_profile_connector_type  = var.connector_profile.connector_type
  connector_profile_connector_label = var.connector_profile.connector_label
  connector_profile_credentials = {
    custom_connector = {
      authentication_type = var.connector_profile.authentication_type
      custom = {
        custom_authentication_type = var.connector_profile.custom_authentication_type
        credentials_map = {
          "username" : jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)[var.github.username]
          "personalAccessToken" : jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)[var.github.PAT]
        }
      }
    }
  }
  connector_profile_properties = {
    custom_connector = {
      oauth2_properties = {
        oauth2_grant_type = var.connector_profile.oauth2_grant_type
        token_url         = var.connector_profile.token_url
      }
    }
  }
}

module "github_flow" {
  source = "./modules/appflow"

  flow_name              = var.appflow.flow_name
  source_connector_type  = var.appflow.source_connector_type
  api_version            = var.appflow.api_version
  connector_profile_name = module.github_connector_profile.connector_profile_name
  source_connector_properties = {
    custom_connector = {
      entity_name = var.appflow.entity_name
    }
  }
  destination_connector_type = var.appflow.destination_connector_type
  destination_connector_properties = {
    s3 = {
      bucket_name = aws_s3_bucket.appflow_bucket.bucket
    }
  }
  task = {
    source_fields     = var.appflow.task.source_fields
    task_type         = var.appflow.task.task_type
    destination_field = var.appflow.task.destination_field
    connector_type    = var.appflow.task.connector_type
    connector_value   = var.appflow.task.connector_value
  }
}