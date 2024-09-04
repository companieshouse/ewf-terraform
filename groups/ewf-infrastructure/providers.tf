provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias   = "cdp_eu_west_2"
  region  = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["cdp"]}:role/${data.aws_caller_identity.current.account_id}-terraform-lookup"
  }
}

provider "aws" {
  alias   = "cdp_development_eu_west_2"
  region  = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["cdp-development"]}:role/${data.aws_caller_identity.current.account_id}-terraform-lookup"
  }
}

provider "aws" {
  alias   = "cdp_staging_eu_west_2"
  region  = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["cdp-staging"]}:role/${data.aws_caller_identity.current.account_id}-terraform-lookup"
  }
}

provider "aws" {
  alias   = "cdp_live_eu_west_2"
  region  = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["cdp-live"]}:role/${data.aws_caller_identity.current.account_id}-terraform-lookup"
  }
}
