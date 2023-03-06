
variable "tags" {
    description = "Map of tags to apply to resources"
    type        = map(any)
    default     = {}
}

variable "bucket_namespace" {
    type        = string
    description = "Define a namespace for all the S3 buckets to be prefixed with; help to ensure consistency, controls, and be unique."
}

variable account_level_s3_access {
    description = "Defines the options available to enable S3 access configurations. this should only be defined once per AWS account."
    type = object({
        enable                  = bool
        block_public_acls       = bool
        block_public_policy     = bool
        ignore_public_acls      = bool
        restrict_public_buckets = bool
    })
    default = {
        enable                  = false
        block_public_acls       = true
        block_public_policy     = true
        ignore_public_acls      = true
        restrict_public_buckets = true
    }
}

variable named_lifecycle_rules {
    description = "Optional, Define your own named lifecycle policies and then reference them in your S3 bucket configuration."
    type        = map(object({
        id          = string
        prefix      = string
        enabled     = bool
        transitions = list(object({
            date            = string
            days            = number
            storage_class   = string
        }))
    }))

    default = {
        basic   = {
            id          = "basic"
            prefix      = ""
            enabled     = true
            transitions = [
                { days = 60, storage_class   = "STANDARD_IA", date = null },
                { days = 90, storage_class   = "GLACIER", date = null }
            ]
        }
    }
}

variable "buckets" {
  description = "List of S3 buckets"
  type = map(object({
    name            = string
    enabled         = bool
    description     = optional(string)
    acl             = optional(string)
    tags            = optional(map(string))
    force_destroy   = optional(bool)

    bucket_access   = optional(object({
      block_public_acls         = optional(string)  
      block_public_policy       = optional(string)
      ignore_public_acls        = optional(string)
      restrict_public_buckets   = optional(string)
    }))        
        
    logging   = optional(list(object({
      s3_bucket = string
      s3_prefix = string
    })))    

    encryption   = optional(list(object({
      kms_master_key_id = string
      sse_algorithm     = string
    })))    

    versioning   = optional(list(object({
      enabled       = string
      mfa_delete    = string
    })))    

    named_lifecycle_rules   = optional(list(string))
  }))
}