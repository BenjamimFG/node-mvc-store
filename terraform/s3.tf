resource "aws_s3_bucket" "static_bucket" {
  bucket = "aqui-express-files"
  tags = {
    "project" = "aqui-express"
  }
}

resource "aws_s3_bucket_ownership_controls" "public_access" {
  depends_on = [ aws_s3_bucket.static_bucket ]
  bucket = aws_s3_bucket.static_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  depends_on = [ aws_s3_bucket.static_bucket ]
    bucket = aws_s3_bucket.static_bucket.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "public_read" {
    depends_on = [
        aws_s3_bucket_ownership_controls.public_access,
        aws_s3_bucket_public_access_block.public_access,
    ]

    bucket = aws_s3_bucket.static_bucket.id
    acl    = "public-read"
}

resource "aws_s3_bucket_policy" "bucket_public_policy" {
    bucket = aws_s3_bucket.static_bucket.id
    policy = data.aws_iam_policy_document.public_bucket_policy_statement.json
}

data "aws_iam_policy_document" "public_bucket_policy_statement" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.static_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_object" "provision_static_files" {
  depends_on = [ aws_s3_bucket.static_bucket ]
  bucket = aws_s3_bucket.static_bucket.id

  for_each = fileset("../static/", "**/*.*")

  key = each.value
  source = "../static/${each.value}"
  content_type = each.value
}