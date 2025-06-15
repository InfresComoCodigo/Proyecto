resource "aws_kms_key" "log_encryption" {
  description             = "KMS key for encrypting CloudWatch logs - Villa Alfredo"
  enable_key_rotation     = true
  deletion_window_in_days = 10

  tags = {
    project     = "Villa Alfredo"
    environment = terraform.workspace
  }
}
