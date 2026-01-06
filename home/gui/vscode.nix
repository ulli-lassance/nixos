{
  pkgs,
  vars,
  ...
}:

{
  home.packages = with pkgs; [
    nil
    nixfmt
  ];

  stylix.targets.vscode = {
    enable = true;
    profileNames = [ "default" ];
    fonts.enable = false;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    dataFolderName = ".vscode-oss";
    nameShort = "VSCodium";
    mutableExtensionsDir = false;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        sumneko.lua
        naumovs.color-highlight
      ];

      userSettings = {
        "workbench.colorTheme" = "Stylix";
        "workbench.startupEditor" = "none";
        "window.zoomLevel" = 0.6;
        "window.newWindowProfile" = "Default";
        "editor.wordWrap" = "on";
        "editor.fontSize" = 16.0;
        "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";

        "editor.unicodeHighlight.allowedCharacters" = {
          "\u001b" = true;
        };

        "git.autofetch" = true;
        "git.suggestSmartCommit" = false;
        "git.openRepositoryInParentFolders" = "always";
        "telemetry.editStats.enabled" = false;
        "telemetry.feedback.enabled" = false;
        "security.workspace.trust.enabled" = false;

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          "nil" = {
            "diagnostics" = {
              "ignored" = [
                "unused_binding"
                "unused_with"
              ];
            };
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
          };

          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            "options" = {
              "nixos" = {
                "expr" = "(builtins.getFlake \"${vars.homeDirectory}/nixos\").nixosConfigurations.desktop.options";
              };
            };
          };
        };
      };
    };
  };
}
