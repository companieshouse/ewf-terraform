# ------------------------------------------------------------------------------
# EWF Key Pair
# ------------------------------------------------------------------------------

resource "aws_key_pair" "ewf_keypair" {
  key_name   = var.application
  public_key = local.ewf_ec2_data["public-key"]
}
