{
  modulesPath,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  programs.mosh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.neovim
	pkgs.unzip
  ];

  virtualisation.docker.enable = true;
  users.users.root.extraGroups = ["docker"];

  services.devmon.enable = true;
  fileSystems."/mnt/external" = {
    device = "/dev/sdb2"; # Replace with your actual device path
    fsType = "auto"; # Replace with your filesystem type
    options = ["nofail"]; # Optional: Prevent errors on mount failure
  };

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA6vVtoHGETo5o7w7bHtEEOkGkOdE3tLX5wN8fW6aUN8 qverkk@yogi"
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1cHOpC1H3YXcMZGsZEdB3WteVcO0ZDGeXlu7p4lTsA root@lab"
  ];

  system.stateVersion = "24.05";
}
