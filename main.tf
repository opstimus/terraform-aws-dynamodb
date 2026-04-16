resource "aws_dynamodb_table" "main" {
  name             = "${var.project}-${var.environment}-${var.name}"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = var.enable_stream
  stream_view_type = var.stream_view_type

  key_schema {
    attribute_name = var.hash_key
    key_type       = "HASH"
  }

  dynamic "key_schema" {
    for_each = var.range_key != null ? [var.range_key] : []
    content {
      attribute_name = key_schema.value
      key_type       = "RANGE"
    }
  }

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  dynamic "attribute" {
    for_each = var.range_key != null ? [{ name = var.range_key, type = var.range_key_type }] : []
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "attribute" {
    for_each = var.additional_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  ttl {
    enabled        = var.ttl_attribute != null ? true : false
    attribute_name = var.ttl_attribute
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes

    content {
      name               = global_secondary_index.value.name
      projection_type    = global_secondary_index.value.projection_type
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)

      key_schema {
        attribute_name = global_secondary_index.value.hash_key
        key_type       = "HASH"
      }

      dynamic "key_schema" {
        for_each = lookup(global_secondary_index.value, "range_key", null) != null ? [global_secondary_index.value.range_key] : []
        content {
          attribute_name = key_schema.value
          key_type       = "RANGE"
        }
      }
    }
  }
}
