{
  config,
  vars,
  pkgs,
  inputs,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
  wallpaper = ./../../../../assets/wallpapers + "/${vars.wallpaper}";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;

    settings = builtins.fromJSON (builtins.readFile ./settings.json);

    colors = {
      mPrimary = colors.base0D;
      mOnPrimary = colors.base00;
      mSecondary = colors.base0E;
      mOnSecondary = colors.base00;
      mTertiary = colors.base0C;
      mOnTertiary = colors.base00;
      mError = colors.base08;
      mOnError = colors.base00;
      mSurface = colors.base00;
      mOnSurface = colors.base05;
      mHover = colors.base0C;
      mOnHover = colors.base00;
      mSurfaceVariant = colors.base01;
      mOnSurfaceVariant = colors.base04;
      mOutline = colors.base03;
      mShadow = colors.base00;
    };
  };

  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON { defaultWallpaper = "${wallpaper}"; };
  };
}
