module "oidc" {
  source              = "../../modules/oidc/"
  env                 = var.env
  project_name        = var.project_name
  github_organisation = var.github_organisation
  github_repo         = var.github_repo
  github_branch       = var.github_branch
  oidc_provider_url   = var.oidc_provider_url
  client_id_list      = var.client_id_list
  thumbprint_list     = var.thumbprint_list
}

module "ecr" {
  source       = "../../modules/ecr/"
  env          = var.env
  project_name = var.project_name
}
