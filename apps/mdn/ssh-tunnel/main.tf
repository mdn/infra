
module "ssh_tunnel_eu_central_1" {
  source     = "./modules/ssh-tunnel"
  region     = "eu-central-1"
  spot_price = "0.0019"
  vpc_id     = data.terraform_remote_state.vpc-eu-central-1.outputs.vpc_id
  zone_id    = data.terraform_remote_state.dns.outputs.eu-central-1-zone-id

  github_users = [
    "limed",
    "escattone",
    "peterbe",
    "schalkneethling"
  ]
}
