{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      border-radius = 10;
      default-timeout = 1000;
      on-button-left = "invoke-custom-action";
      on-button-middle = "invoke-default-action";
      on-button-right = "invoke-default-action";
      on-touch = "invoke-default-action";
      custom-action = "sh -c 'makoctl menu -n %i wofi -d -p 'Select Action...' && makoctl dismiss %i'";
    };
  };
  home.packages = with pkgs; [ libnotify ];
}
