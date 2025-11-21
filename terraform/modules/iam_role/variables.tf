variable "name" { 
    type = string 
    description = "The name of the IAM role"
    }
variable "assume_role_policy" { 
    type = string 
    description = "The assume role policy in JSON format"
    }
variable "managed_policy_arns" { 
    type = list(string) 
    default = [] 
    description = "List of managed policy ARNs to attach to the role"
    }
variable "inline_policies" { 
    type = map(string) 
    default = {} 
    description = "Map of inline policy names to JSON policy documents"
    }
variable "tags" { 
    type = map(string) 
    default = {} 
    description = "Tags to assign to the IAM role"
    }   