# /etc/nixos/secret/default.nix
{
  tailscale = {
    clientId = "kxixTezVgB21CNTRL";
    clientSecret = "tskey-client-kxixTezVgB21CNTRL-jiN4D8nU7sbYCg1vcCtWrb1nA2D4gRCa";
  };

  pihole = {
    password = "$BALLOON-SHA256$v=1$s=1024,t=32$p2M4OlLbz2IetFKAhRbLTA==$qq7ANG2xvsLR9JWGUUgoqBSI7HTBRQd9LbgrYZiegn0=";
    # pwhash = "
  };

  # Vantagem do Barrel Centralizado: Próximos segredos entram direto aqui embaixo
  # postgres = { ... };
}
