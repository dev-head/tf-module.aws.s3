Terraform AWS :: S3 Module
==========================

Description
-----------
Terraform AWS S3 Module for configuration of one or more s3 buckets. 

Example
-------
> [Example Module](./example/default) found in `./example/default`
* [Terraform Docs on S3](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)


Behaviors 
---------
Unless otherwise defined in a bucket `bucket_access` configuration, we default 
to disable and bloc public access. 

      
Usage :: Defined Variables
--------------------------- 
```hcl-terraform
module "s3" {
    source                  = "git@github.com:dev-head/tf-module.aws.s3.git?ref=0.0.1"
    tags                    = {ManagedBy = "Terraform"}
    bucket_namespace        = "my-prefix--"
    buckets                 = {
      test_bucket_001    = {
          enabled     = true
          name        = "test-bucket-001"
          description = "Bucket created to test normal configurations."
          acl         = "private"
          bucket_access   = {
            block_public_acls   = true, block_public_policy = true,
            ignore_public_acls  = true, restrict_public_buckets = true
          }
          force_destroy           = false
          named_lifecycle_rules   = ["default"]
          logging                 = []
          encryption              = []
          versioning              = [{ enabled = true, mfa_delete = false }]
          tags                    = {Project = "test-bucket-001"}
        }
        
        test_bucket_002    = {
          name    = "test-bucket-002"
          enabled = true
        }      
    }

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
```


Outputs 
-------
| key               | type      | Description 
|:-----------------:|:---------:| ------------------------------------------------------------------------------------:| 
| apply_metadata    | string    | Output metadata regarding the apply.
| key_attributes    | object    | Map of maps, indexed by they `var.keys` key, to ensure it's accessible.
| key_resources     | object    | Provide full access to resource objects.

#### Example
```
key_attributes = {
  "test_bucket_001" = {
    "arn" = "arn:aws:s3:::smynamespace--bucket-001"
    "bucket_domain_name" = "mynamespace--bucket-001.s3.amazonaws.com"
    "id" = "mynamespace--bucket-001"
  }
  "test_bucket_002" = {
    "arn" = "arn:aws:s3:::mynamespace--bucket-002"
    "bucket_domain_name" = "mynamespace--bucket-002.s3.amazonaws.com"
    "id" = "mynamespace--bucket-002"
  }
}

```

