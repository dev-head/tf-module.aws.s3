
output "apply_metadata" {
  description = "Output metadata regarding the apply."
  value       = format("[%s]::[%s]::[%s]",
      data.aws_caller_identity.current.account_id,
      data.aws_caller_identity.current.arn,
      data.aws_caller_identity.current.user_id
  )
}

output  "key_attributes" {
    description = "Map of maps, indexed by they `var.keys` key, to ensure it's accessible."
    value = {
        for key,v in local.active_buckets : key => {
            arn                 = aws_s3_bucket.bucket[key].arn
            id                  = aws_s3_bucket.bucket[key].id
            bucket_domain_name  = aws_s3_bucket.bucket[key].bucket_domain_name
        }
    }
}

output  "key_resources" {
    description = "Provide full access to resource objects."
    value = {
        for key,v in local.active_buckets : key => {
            bucket = aws_s3_bucket.bucket[key]
        }
    }
}

output "aws_caller_identity" { value = data.aws_caller_identity.current }
output "aws_region" { value = data.aws_region.current }