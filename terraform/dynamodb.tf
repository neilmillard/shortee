resource "aws_dynamodb_table" "short_url" {
  name             = "${module.label.id}-ShortUrl"
  hash_key         = "slug"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "OLD_IMAGE"

  attribute {
    name = "slug"
    type = "S"
  }

  ttl {
    attribute_name = "expiry_timestamp"
    enabled        = true
  }
}
