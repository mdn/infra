module "ssh_tunnel_us_west_2" {
  source     = "./modules/ssh-tunnel"
  region     = "us-west-2"
  spot_price = "0.0021"
  vpc_id     = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  zone_id    = data.terraform_remote_state.dns.outputs.us-west-2-zone-id

  github_users = [
    "fiji-flo",
    "schalkneethling",
    # Web SRE Team
    # According to https://github.com/orgs/mozilla-it/teams/it-se/members?query=membership:child-team
    "bkochendorfer",
    "duallain",
    "floatingatoll",
    "smarnach",
    "cmharlow"
  ]
}
