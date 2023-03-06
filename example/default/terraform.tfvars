aws_profile = ""
aws_region  = "ab-cdefg-13"

#-{define module variables}----------------------------------------------------------------------------------------#
bucket_namespace = "mynamespace--"

tags = {
  Project     = "example"
  Environment = "Test"
  ManagedBy   = "terraform"
}

account_level_s3_access = {
  enable                  = false
  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

named_lifecycle_rules = {
  access_logs = {
    id          = "rule_for_access_logs"
    prefix      = ""
    enabled     = true
    transitions = [
      { days = 60, storage_class = "STANDARD_IA", date = null },
      { days = 90, storage_class = "GLACIER", date = null }
    ]
  }

  default = {
    id          = "default_custom_rule"
    prefix      = ""
    enabled     = true
    transitions = [
        { days = 180, storage_class = "STANDARD_IA", date = null },
        { days = 210, storage_class = "GLACIER", date = null }
    ]
  }
}

buckets = {
  
  # Bucket for logging.
  logging_bucket  = {
    enabled                     = true
    name                        = "test-s3-access-logs"
    description                 = "Example bucket for all S3 access logs to be directed to."
    acl                         = "log-delivery-write"
    bucket_access   = {
      block_public_acls = true, block_public_policy = true,
      ignore_public_acls = true, restrict_public_buckets = true
    }
    force_destroy               = false
    named_lifecycle_rules       = ["access_logs"]
    logging                     = []
    encryption                  = [{
      kms_master_key_id   = "arn:aws:kms:AWS-REGION-ID:ACCOUNT_ID:alias/KMS_ALIAS_NAME"
      sse_algorithm       = "aws:kms"
    }]
    versioning                  = []
    tags                        = {testing = "and resting"}
  }
  
  # Minimal bucket configuration
  test_bucket_001    = {
    name = "test-bucket-001"
    enabled = true
  }
  
  
  # Basic bucket, with defined configurations. 
  test_bucket_002    = {
    enabled      = true
    name        = "test-bucket-002"
    description = "Bucket created to test normal configurations."
    acl         = "private"
    bucket_access   = {
      block_public_acls = true, block_public_policy = true,
      ignore_public_acls = true, restrict_public_buckets = true
    }
    force_destroy           = false
    named_lifecycle_rules   = ["default"]
    logging                 = []
    encryption              = []
    versioning              = [{ enabled = true, mfa_delete = false }]
    tags                    = {Project = "test-bucket-002"}
  }
}