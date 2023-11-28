#we have three types of generic variables

#Business variable
variable "Business" {
  description = "business variable"
  type        = string
  default     = "sap"

}

#environment variable
variable "environment" {
  description = "specifying the environment"
  type        = string
  default     = "dev"

}