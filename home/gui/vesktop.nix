{ pkgs, ... }:

{
  stylix.targets.vesktop.enable = true;

  xdg.configFile."vesktop/settings/quickCss.css".text = ''
    @import url(https://croissantdunord.github.io/discord-adblock/adblock.css);
  '';

  programs.vesktop = {
    enable = true;
    package = pkgs.vesktop;
    settings = {
      appBadge = false;
      arRPC = false;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;
      minimizeToTray = false;
      tray = true;
      hardwareAcceleration = true;
      discordBranch = "stable";
    };

    vencord = {
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        useQuickCss = true;

        plugins = {
          FakeNitro.enabled = true;

          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
            ignoreBots = true;
          };

          SilentTyping = {
            enabled = true;
            showIcon = true;
            contextMenu = true;
          };

          ClearURLs.enabled = true;

        };
      };
    };
  };
}
