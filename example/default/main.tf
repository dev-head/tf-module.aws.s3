#------------------------------------------------------------------------------#
# @title: Terraform Example
# @description: Used to test and provide a working example for this module.
#------------------------------------------------------------------------------#

terraform {
  required_version = "~> 1.1.9"
  experiments = [module_variable_optional_attrs]  
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "example" {
    source                      = "../../"
    tags                        = {ManagedBy = "Terraform"}
    bucket_namespace            = ""
    buckets                     = var.buckets
    named_lifecycle_rules       = {
        basic   = {
            id          = "basic"
            prefix      = ""
            enabled     = true
            transitions = [
                { days = 60, storage_class = "STANDARD_IA", date = null },
                { days = 90, storage_class = "GLACIER", date = null }
            ]
        }
    }

    account_level_s3_access     = {
        enable                  = false
        block_public_acls       = true
        block_public_policy     = true
        ignore_public_acls      = true
        restrict_public_buckets = true
    }
}

output "metadata" {
    description = "Output metadata regarding the apply."
    value       = module.example.apply_metadata
}

output "key_attributes" {
    description = "Output key attributes from this module."
    value       = module.example.key_attributes
}
