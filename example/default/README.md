Example :: S3
=============


Description
-----------
Example of a minimal configuration for S3 buckets.


#### Change to required Terraform Version
```commandline
chtf 1.1.9
```

#### Make commands (includes local.ini support)
```commandline
make apply
make help
make plan
```

Example Outputs 
---------------
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