{ lib, vars, ... }:

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

    bind = [
      # App shortcuts
      {
        _args = [
          "${mainMod} + Return"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${terminal}\")")
        ];
      }
      {
        _args = [
          "${mainMod} + B"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${browser}\")")
        ];
      }
      {
        _args = [
          "${mainMod} + C"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${editor}\")")
        ];
      }
      {
        _args = [
          "${mainMod} + E"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${fileManager}\")")
        ];
      }

      # Noctalia
      {
        _args = [
          "${mainMod} + S"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${ipc} launcher toggle\")")
        ];
      }
      {
        _args = [
          "${mainMod} + Tab"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${ipc} launcher windows\")")
        ];
      }
      {
        _args = [
          "${mainMod} + M"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${ipc} sessionMenu toggle\")")
        ];
      }
      {
        _args = [
          "${mainMod} + L"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${ipc} lockScreen lock\")")
        ];
      }

      # Screenshots
      {
        _args = [
          "${mainMod} + P"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprshot -zm region -o ~/Pictures/Screenshots\")")
        ];
      }

      # Window control
      {
        _args = [
          "${mainMod} + Q"
          (lib.generators.mkLuaInline "hl.dsp.window.close()")
        ];
      }
      {
        _args = [
          "${mainMod} + W"
          (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
        ];
      }
      {
        _args = [
          "${mainMod} + F"
          (lib.generators.mkLuaInline "hl.dsp.fullscreen()")
        ];
      }
      {
        _args = [
          "${mainMod} + K"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"~/.config/hypr/scripts/cycle_kb_layout\")")
        ];
      }

      # Dwindle layout
      {
        _args = [
          "${mainMod} + U"
          (lib.generators.mkLuaInline "hl.dsp.layout(\"togglesplit\")")
        ];
      }
      {
        _args = [
          "${mainMod} + I"
          (lib.generators.mkLuaInline "hl.dsp.layout(\"swapsplit\")")
        ];
      }
      {
        _args = [
          "${mainMod} + mouse_down"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"e+1\" })")
        ];
      }
      {
        _args = [
          "${mainMod} + mouse_up"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"e-1\" })")
        ];
      }
      {
        _args = [
          "${mainMod} + A"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"~/.config/hypr/scripts/move_active_to_empty\")")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + A"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"~/.config/hypr/scripts/move_active_to_empty_silent\")")
        ];
      }

      # Focus movement
      {
        _args = [
          "${mainMod} + left"
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"l\" })")
        ];
      }
      {
        _args = [
          "${mainMod} + right"
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"r\" })")
        ];
      }
      {
        _args = [
          "${mainMod} + up"
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"u\" })")
        ];
      }
      {
        _args = [
          "${mainMod} + down"
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"d\" })")
        ];
      }

      # Workspaces
      {
        _args = [
          "${mainMod} + 1"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 1 })")
        ];
      }
      {
        _args = [
          "${mainMod} + 2"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 2 })")
        ];
      }
      {
        _args = [
          "${mainMod} + 3"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 3 })")
        ];
      }
      {
        _args = [
          "${mainMod} + 4"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 4 })")
        ];
      }
      {
        _args = [
          "${mainMod} + 5"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 5 })")
        ];
      }
      {
        _args = [
          "${mainMod} + 6"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 6 })")
        ];
      }
      {
        _args = [
          "${mainMod} + 7"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 7 })")
        ];
      }
      {
        _args = [
          "${mainMod} + 8"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 8 })")
        ];
      }
      {
        _args = [
          "${mainMod} + 9"
          (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 9 })")
        ];
      }

      # Move window to workspace
      {
        _args = [
          "${mainMod} + SHIFT + 1"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 1 })")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + 2"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 2 })")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + 3"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 3 })")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + 4"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 4 })")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + 5"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 5 })")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + 6"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 6 })")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + 7"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 7 })")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + 8"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 8 })")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + 9"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 9 })")
        ];
      }

      # Audio (locked = works on lock screen)
      {
        _args = [
          "XF86AudioRaiseVolume"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${ipc} volume increase\")")
          { locked = true; }
        ];
      }
      {
        _args = [
          "XF86AudioLowerVolume"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${ipc} volume decrease\")")
          { locked = true; }
        ];
      }
      {
        _args = [
          "XF86AudioMute"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${ipc} volume muteOutput\")")
          { locked = true; }
        ];
      }

      # Mouse binds
      {
        _args = [
          "${mainMod} + mouse:272"
          (lib.generators.mkLuaInline "hl.dsp.window.drag()")
          { mouse = true; }
        ];
      }
      {
        _args = [
          "${mainMod} + mouse:273"
          (lib.generators.mkLuaInline "hl.dsp.window.resize()")
          { mouse = true; }
        ];
      }

      # Resize (repeating = hold to repeat)
      {
        _args = [
          "${mainMod} + SHIFT + Right"
          (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 30, y = 0, relative = true })")
          { repeating = true; }
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + Left"
          (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = -30, y = 0, relative = true })")
          { repeating = true; }
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + Up"
          (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = -30, relative = true })")
          { repeating = true; }
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + Down"
          (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = 30, relative = true })")
          { repeating = true; }
        ];
      }
    ];
  };
}
