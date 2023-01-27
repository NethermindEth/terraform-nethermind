variable "num" {
  description = "Number of VM's with preconfigured Nethermind Docker environment to create"
  type        = number
  default     = 1
}

variable "pvt_key" {
  description = "Path to private key for SSH connection to VM"
  type        = string
}

variable "prefix" {
  description = "Instance prefix, this will be the basename of the host (e.g. <instance_name>-<instance-region>-<count>v)"
  type        = string
  default     = "nethermind"
}

# variable "client_count" {
#   description = "Number of Nethermind clients which will be running on each VM (e.g. --scale nethermind=5)"
#   type = number
# }

variable "config" {
  description = "Chain on which Nethermind will be running e.g. goerli or mainnet"
  type        = string
  default     = "goerli"
}

variable "rpc_enabled" {
  description = "Specify whether JSON RPC should be enabled"
  type        = bool
  default     = true
}

variable "sizeList" {
  type = map(any)
  default = {
    "s-1vcpu-2gb" = "s-1vcpu-2gb"
    "s-2vcpu-2gb" = "s-2vcpu-2gb"
    "s-2vcpu-4gb" = "s-2vcpu-4gb"
    "s-4vcpu-8gb" = "s-4vcpu-8gb"
  }
}

variable "size" {
  description = <<EOT
"Choose VM size you wish to deploy e.g. s-2vcpu-2gb
List of mappings is displayed below:
s-1vcpu-2gb = 12USD
s-2vcpu-2gb = 18USD
s-2vcpu-4gb = 24USD
s-4vcpu-8gb = 48USD"
EOT
  type        = string
  default     = "s-1vcpu-2gb"
}

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}
