{ vars, ... }:

let
  mainMod = "SUPER";
  ipc = "noctalia-shell ipc call";
  terminal = vars.terminal;
  fileManager = vars.fileManager;
  browser = vars.browser;
  editor = vars.editor;
in
{
  wayland.windowManager.hyprland.settings = {

    # Standard Keybinds
    bind = [
      # App shortcuts
      "${mainMod}, Return, exec, ${terminal}"
      "${mainMod}, B, exec, ${browser}"
      "${mainMod}, C, exec, ${editor}"
      "${mainMod}, E, exec, ${fileManager}"

      # Noctalia
      "${mainMod}, S, exec, ${ipc} launcher toggle"
      "${mainMod}, TAB, exec, ${ipc} launcher windows"
      "${mainMod}, M, exec, ${ipc} sessionMenu toggle"
      "${mainMod}, L, exec, ${ipc} lockScreen lock"

      # Window control
      "${mainMod}, Q, killactive"
      "${mainMod}, W, togglefloating"
      "${mainMod}, F, fullscreen"
      "${mainMod}, U, layoutmsg, togglesplit"
      "${mainMod}, I, layoutmsg, swapsplit"
      "${mainMod}, K, exec, ~/.config/hypr/scripts/cycle_kb_layout"

      # Focus movement
      "${mainMod}, left, movefocus, l"
      "${mainMod}, right, movefocus, r"
      "${mainMod}, up, movefocus, u"
      "${mainMod}, down, movefocus, d"

      # Workspaces
      "${mainMod}, 1, workspace, 1"
      "${mainMod}, 2, workspace, 2"
      "${mainMod}, 3, workspace, 3"
      "${mainMod}, 4, workspace, 4"
      "${mainMod}, 5, workspace, 5"
      "${mainMod}, 6, workspace, 6"
      "${mainMod}, 7, workspace, 7"
      "${mainMod}, 8, workspace, 8"
      "${mainMod}, 9, workspace, 9"

      # Move window to workspace
      "${mainMod} SHIFT, 1, movetoworkspace, 1"
      "${mainMod} SHIFT, 2, movetoworkspace, 2"
      "${mainMod} SHIFT, 3, movetoworkspace, 3"
      "${mainMod} SHIFT, 4, movetoworkspace, 4"
      "${mainMod} SHIFT, 5, movetoworkspace, 5"
      "${mainMod} SHIFT, 6, movetoworkspace, 6"
      "${mainMod} SHIFT, 7, movetoworkspace, 7"
      "${mainMod} SHIFT, 8, movetoworkspace, 8"
      "${mainMod} SHIFT, 9, movetoworkspace, 9"

      # Move window to first empty workspace
      "${mainMod}, A, exec, ~/.config/hypr/scripts/move_active_to_empty"
      "${mainMod} SHIFT, A, exec, ~/.config/hypr/scripts/move_active_to_empty_silent"

      # Scroll through workspaces
      "${mainMod}, mouse_down, workspace, e+1"
      "${mainMod}, mouse_up, workspace, e-1"

      # Screenshots
      "${mainMod}, P, exec, hyprshot -zm region -o ~/Pictures/Screenshots"

    ];

    bindel = [
       # Audio
      ", XF86AudioRaiseVolume, exec, ${ipc} volume increase"
      ", XF86AudioLowerVolume, exec, ${ipc} volume decrease"
      ", XF86AudioMute, exec, ${ipc} volume muteOutput"
    ];

    # Mouse binds (Move/Resize)
    bindm = [
      "${mainMod}, mouse:272, movewindow"
      "${mainMod}, mouse:273, resizewindow"
      "${mainMod}, Z, movewindow"
      "${mainMod}, X, resizewindow"
    ];

    # Repeating binds (Resize)
    binde = [
      "${mainMod}+Shift, Right, resizeactive, 30 0"
      "${mainMod}+Shift, Left, resizeactive, -30 0"
      "${mainMod}+Shift, Up, resizeactive, 0 -30"
      "${mainMod}+Shift, Down, resizeactive, 0 30"
    ];
  };
}
