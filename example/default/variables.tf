
variable "aws_region" {
    description = "Requried, AWS region for this to be applied to."
    type        = string
}

variable "aws_profile" {
    description = "Optional, Provider AWS profile name for local aws cli configuration."
    type        = string
    default     = ""
}

#-{Module Variables}--------------------------------------------------------------------------------------------------->


variable "buckets" {
  description = "List of S3 buckets"
  type = map(object({
    name            = string
    enabled         = bool
    description     = optional(string)
    acl             = optional(string)
    tags            = optional(map(string))
    force_destroy   = optional(bool)

    bucket_access = optional(object({
      block_public_acls       = optional(string)  
      block_public_policy     = optional(string)
      ignore_public_acls      = optional(string)
      restrict_public_buckets = optional(string)
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
      enabled     = string
      mfa_delete  = string
    })))    

    named_lifecycle_rules   = optional(list(string))
  }))
}
