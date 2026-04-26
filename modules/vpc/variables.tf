variable "vpc_cidr" {}
variable "public_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
}