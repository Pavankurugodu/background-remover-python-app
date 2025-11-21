variable "cluster_name" { 
  type = string 
  description = "The name of the EKS cluster"
  }
variable "vpc_id" { 
  type = string 
  description = "The ID of the VPC where the EKS cluster will be deployed"
  }
variable "private_subnet_ids" { 
  type = list(string) 
  description = "List of private subnet IDs for the EKS cluster"
  }
variable "public_subnet_ids" { 
  type = list(string) 
  default = [] 
  description = "List of public subnet IDs for the EKS cluster"
  }
variable "cluster_version" { 
  type = string 
  default = "1.29" 
  description = "The Kubernetes version for the EKS cluster"
  }
variable "node_group" {
  type = object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    disk_size      = number
  })
  default = { instance_types = ["t3.medium"], desired_size = 2, min_size = 1, max_size = 3, disk_size = 20 }
}
variable "tags" { 
  type = map(string) 
  default = {} 
  description = "Tags to assign to the EKS cluster"
  }