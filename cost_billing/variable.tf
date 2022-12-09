variable "region" {
  description = "You should choose one of following reagions,because of SESavailability: us-east-1,us-west-2,eu-west-1"
  default     = "us-east-1"
}


variable "client_name" {
  description = "Client name"
  default     = "prabhat"
}

variable "tag_environment" {
  description = "Environment for the infrastructure"
  default     = "prabhatdwivedi"
}

variable "filename" {
  description = "File name"
  default     = "cost_explorer.zip"
}

variable "lambda_timeout" {
  description = "Lambda timeout"
  default     = "300"
}

variable "cron_job" {
  description = "cron job"
  default     = "cron(0 14 * * *)"
}

variable "ses_sender" {
  description = "sender of the email"
  default     = "dwivedi.prabhat@tftus.com"
}

variable "ses_subject" {
  description = "subject of the email"
  default     = "Billing"
}

variable "ses_recipient" {
  description = "recipient of the email"
  default     = "dwivedi.prabhat@tftus.com"
}

variable "owner" {
  default = "Used to identify who is responsible for the resource"
}

variable "tag_deployment_method" {
  default     = "tf"
  description = "How was the module deployed"
}

variable "lambda_zip_file_name" {
  default = "cost_explorer.zip"
}