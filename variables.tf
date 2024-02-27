variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "name" {
  type        = string
  description = "Table name"
}

variable "hash_key" {
  type    = string
  default = "id"
}

variable "hash_key_type" {
  type    = string
  default = "S"
}

variable "range_key" {
  type    = string
  default = "sk"
}

variable "range_key_type" {
  type    = string
  default = "S"
}

variable "additional_attributes" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of additional attributes"
  default     = []
}

variable "ttl_attribute" {
  type        = string
  default     = null
  description = "Enable TTL when this parameter is defined"
}

variable "global_secondary_indexes" {
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  description = "List of global secondary indexes"
  default     = null
}

variable "enable_stream" {
  type    = bool
  default = false
}

variable "stream_view_type" {
  type    = string
  default = "NEW_IMAGE"
}
