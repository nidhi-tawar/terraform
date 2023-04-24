#GitHub Access token
variable "access_token" {
  type        = string
  description = "Access token for GitHUb"
  sensitive   = true
}

variable "domain" {
  type        = string
  description = "Name of the Domain"
}

variable "repository" {
  type        = string
  description = "Name of the Repository"
}


#Global varibales
variable "global_variables" {
  type        = map(string)
  description = "Variables need to stored globally."
  sensitive   = true
}

