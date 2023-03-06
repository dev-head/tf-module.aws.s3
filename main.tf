

resource "aws_s3_account_public_access_block" "default" {
  count                   = lookup(var.account_level_s3_access, "enable", false)? 1 : 0
  block_public_acls       = lookup(var.account_level_s3_access, "block_public_acls", true)
  block_public_policy     = lookup(var.account_level_s3_access, "block_public_policy", true)
  ignore_public_acls      = lookup(var.account_level_s3_access, "ignore_public_acls", true)
  restrict_public_buckets = lookup(var.account_level_s3_access, "restrict_public_buckets", true)
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  for_each                = local.active_buckets
  bucket                  = aws_s3_bucket.bucket[each.key].bucket
  block_public_acls       = coalesce(try(each.value["bucket_access"]["block_public_acls"], false), false) ? lookup(each.value["bucket_access"], "block_public_acls") : true
  block_public_policy     = coalesce(try(each.value["bucket_access"]["block_public_policy"], false), false) ? lookup(each.value["bucket_access"], "block_public_policy") : true
  ignore_public_acls      = coalesce(try(each.value["bucket_access"]["ignore_public_acls"], false), false) ? lookup(each.value["bucket_access"], "ignore_public_acls") : true
  restrict_public_buckets = coalesce(try(each.value["bucket_access"]["restrict_public_buckets"], false), false) ? lookup(each.value["bucket_access"], "restrict_public_buckets") : true
}

resource "aws_s3_bucket" "bucket" {
  for_each        = local.active_buckets
  bucket          = format("%s%s", var.bucket_namespace, lookup(each.value, "name"))
  acl             = lookup(each.value, "acl", "private")
  force_destroy   = lookup(each.value, "force_destroy", false)
  tags            = merge(var.tags, {"Name": format("%s%s", var.bucket_namespace, lookup(each.value, "name"))}, lookup(each.value, "tags"))

  dynamic "logging" {
    for_each = coalesce(each.value["logging"], [])

    content {
      target_bucket = lookup(logging.value, "s3_bucket", null)
      target_prefix = lookup(logging.value, "s3_prefix", null)
    }
  }

  dynamic "versioning" {
    for_each = coalesce(each.value["versioning"], [])
    
    content {
      enabled     = lookup(versioning.value, "enabled", false)
      mfa_delete  = lookup(versioning.value, "mfa_delete", false)
    }
  }
  
  # @NOTE This is deprecated but the new resource [doesn't support loops](https://github.com/hashicorp/terraform-provider-aws/issues/23243)
  dynamic "lifecycle_rule" {
    for_each = coalesce(each.value["named_lifecycle_rules"], [])

    content {
      id      = lookup(lookup(var.named_lifecycle_rules, lifecycle_rule.value), "id")
      prefix  = lookup(lookup(var.named_lifecycle_rules, lifecycle_rule.value), "prefix")
      enabled = lookup(lookup(var.named_lifecycle_rules, lifecycle_rule.value), "enabled")

      dynamic "transition" {
        for_each = lookup(lookup(var.named_lifecycle_rules, lifecycle_rule.value), "transitions")
        content {
          days            = lookup(transition.value, "days")
          storage_class   = lookup(transition.value, "storage_class")
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = coalesce(each.value["encryption"], [])
    
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = lookup(server_side_encryption_configuration.value, "kms_master_key_id")
          sse_algorithm     = lookup(server_side_encryption_configuration.value, "sse_algorithm", )
        }
      }
    }
  }
}
