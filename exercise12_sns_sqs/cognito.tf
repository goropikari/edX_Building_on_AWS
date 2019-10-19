resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.domain
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}

resource "aws_cognito_user_pool" "pool" {
  name                     = "photos-pool"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  schema {
    name                = "nickname"
    attribute_data_type = "String"
    mutable             = false
    required            = true

    string_attribute_constraints {
      min_length = 1
      max_length = 20
    }
  }

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
    unused_account_validity_days = 7
  }
  mfa_configuration = "OFF"

  verification_message_template {
    default_email_option = "CONFIRM_WITH_LINK"
    email_subject        = "Your verification link"
    email_message        = "Please click the link below to verify your email address. {####} "
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "client"
  supported_identity_providers         = ["COGNITO"]
  user_pool_id                         = aws_cognito_user_pool.pool.id
  generate_secret                      = true
  callback_urls                        = ["https://${aws_cloud9_environment_ec2.example.id}.vfs.cloud9.us-west-2.amazonaws.com/callback"]
  logout_urls                          = ["https://${aws_cloud9_environment_ec2.example.id}.vfs.cloud9.us-west-2.amazonaws.com/"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["openid"]
}

output "user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "user_pool_client_secret" {
  value = aws_cognito_user_pool_client.client.client_secret
}

output "cognito_domain" {
  value = "https://${var.domain}.auth.us-west-2.amazoncognito.com"
}
