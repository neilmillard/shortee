variable "environment" {}
variable "aws_account_numbers" {}
variable "name" {
  description = "Name of the VPC"
}
variable "cidr_block" {
  description = "CIDR block allocation for the VPC (check this does not overlap other VPC CIDR blocks)"
}
variable "subnet_bits" {
  description = "Number of bits for subnet addressing (eg. set to 4 on a /18 VPC that will yield /22 subnets)"
  default     = 4
}
variable "subnet_step" {
  description = "Offset between the start of the private subnet cidrs and the public subnet cidrs."
  default     = 8
}
variable "vpc_peering_id" {
  description = "The ID of the VPC peering"
  default     = ""
}

variable "retention_in_days" {
  default = "5"
}

variable "create_public_subnets" {
  default = false
}

variable "create_interface_endpoints" {
  default = false
}

variable "create_gateway_endpoints" {
  default = false
}

variable "create_intra_subnets" {
  default = false
}
variable "enable_nat_gateway" {
  default = false
}
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}
variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "tags" {
  type = map(string)
}
variable "execute_api_private_dns_enabled" {
  type    = bool
  default = false
}
variable "aws_interface_endpoints" {
  type    = list(string)
  default = ["ecs", "logs", "ec2", "sts", "monitoring"]
}

variable "aws_gateway_endpoints" {
  type    = list(string)
  default = ["s3"]
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "intra_subnets" {
  description = "A list of intra subnets"
  type        = list(string)
  default     = []
}
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}