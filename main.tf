resource "aws_dynamodb_table" "main" {
  name             = "${var.project}-${var.environment}-${var.name}"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = var.enable_stream
  stream_view_type = var.stream_view_type

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  attribute {
    name = var.range_key
    type = var.range_key_type
  }

  ttl {
    enabled        = var.ttl_attribute != null ? true : false
    attribute_name = var.ttl_attribute
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes != null ? var.global_secondary_indexes : []
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      projection_type    = global_secondary_index.value.projection_type
      read_capacity      = global_secondary_index.value.read_capacity
      write_capacity     = global_secondary_index.value.write_capacity
      non_key_attributes = global_secondary_index.value.non_key_attributes
    }
  }
}

