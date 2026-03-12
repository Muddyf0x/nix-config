{ config, ...}:
{
  sops.secrets.test-password.needdedForUsers = true;
  users.mutableUsers = true;

  users.users.test = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.test.path;
  };
}
