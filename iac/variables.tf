variable "region" {
  type    = string
  default = "us-west-1"
}

variable "environment" {
  type = string
}

variable "textract_form_adapters_env_var_mapping" {
  type      = map(string)
  sensitive = true
  nullable  = true
}
