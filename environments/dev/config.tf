variable "github_repo" {
  type = string
}

variable "github_organisation" {
  type = string
}

variable "github_branch" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "thumbprint_list" {
  type = list(string)
}

variable "client_id_list" {
  type = list(string)
}
