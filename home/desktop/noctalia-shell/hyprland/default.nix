{
  pkgs,
  config,
  vars,
  ...
}:

{
  wayland.windowManager.hyprland = {
    enable = true;
    # Set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    systemd = {
      enable = false;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
  };

  home.packages = with pkgs; [
    hyprshot
  ];

  xdg.configFile = with config.lib.stylix.colors; {
    "hypr/vars.lua".text = ''
      _G.vars = {
        layout = "master",

        fileManager = "${vars.fileManager}",
        editor = "${vars.editor}",
        terminal = "${vars.terminal}",
        browser = "${vars.browser}",

        shadow_color = "0xff${base00}",
        active_border_color = "0xff${base0D}",
        inactive_border_color = "0xff${base03}"
      }
    '';

    "hypr/hyprland.lua".source = ./config/hyprland.lua;
    "hypr/animations.lua".source = ./config/animations.lua;
    "hypr/rules.lua".source = ./config/rules.lua;
    "hypr/binds.lua".source = ./config/binds.lua;
    "hypr/env.lua".source = ./config/env.lua;

    "hypr/xdph.conf".text = ''
      screencopy {
          allow_token_by_default = true
      }
    '';
  };
}
