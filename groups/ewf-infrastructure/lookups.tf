module "cdp_eu_west_2_lookups" {
  source = "git@github.com:companieshouse/terraform-modules//aws/subnet-lookup?ref=tags/1.0.287"

  providers = {
    aws = aws.cdp_eu_west_2
  }

  count = length(local.cdp_eu_west_2_lookups)

  subnet_pattern = local.cdp_eu_west_2_lookups[count.index].subnet_pattern
  vpc_pattern = local.cdp_eu_west_2_lookups[count.index].vpc_pattern
}

module "cdp_development_eu_west_2_lookups" {
  source = "git@github.com:companieshouse/terraform-modules//aws/subnet-lookup?ref=tags/1.0.287"

  providers = {
    aws = aws.cdp_development_eu_west_2
  }

  count = length(local.cdp_development_eu_west_2_lookups)

  subnet_pattern = local.cdp_development_eu_west_2_lookups[count.index].subnet_pattern
  vpc_pattern = local.cdp_development_eu_west_2_lookups[count.index].vpc_pattern
}

module "cdp_staging_eu_west_2_lookups" {
  source = "git@github.com:companieshouse/terraform-modules//aws/subnet-lookup?ref=tags/1.0.287"

  providers = {
    aws = aws.cdp_staging_eu_west_2
  }

  count = length(local.cdp_staging_eu_west_2_lookups)

  subnet_pattern = local.cdp_staging_eu_west_2_lookups[count.index].subnet_pattern
  vpc_pattern = local.cdp_staging_eu_west_2_lookups[count.index].vpc_pattern
}

module "cdp_live_eu_west_2_lookups" {
  source = "git@github.com:companieshouse/terraform-modules//aws/subnet-lookup?ref=tags/1.0.287"

  providers = {
    aws = aws.cdp_live_eu_west_2
  }

  count = length(local.cdp_live_eu_west_2_lookups)

  subnet_pattern = local.cdp_live_eu_west_2_lookups[count.index].subnet_pattern
  vpc_pattern = local.cdp_live_eu_west_2_lookups[count.index].vpc_pattern
}
