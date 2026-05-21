{ ... }:

{
  imports = [ ./theme.nix ];

  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
    };

    keybindings = {
      "ctrl+c" = "copy_and_clear_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
    };

    settings = {
      include = "theme.conf";
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
      linux_display_server = "auto";
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
    };
  };

}
