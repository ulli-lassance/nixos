{ ... }:

{
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        separator = "› ";
        size = {
          binaryPrefix = "si";
        };
      };

      modules = [
        {
          type = "custom";
          format = "{#34}╭──────────── {#35}Software {#34}────────────";
        }
        {
          type = "os";
          key = "│ OS";
          keyColor = "blue";
        }
        {
          type = "kernel";
          key = "│ Kernel";
          keyColor = "blue";
        }
        {
          type = "packages";
          key = "│ Packages";
          keyColor = "blue";
        }
        {
          type = "shell";
          key = "│ Shell";
          keyColor = "blue";
        }
        {
          type = "de";
          key = "│ DE";
          keyColor = "blue";
        }
        {
          type = "terminal";
          key = "│ Terminal";
          keyColor = "blue";
        }
        {
          type = "localip";
          key = "│ Local IP";
          keyColor = "blue";
        }

        {
          type = "custom";
          format = "{#34}├──────────── {#35}Hardware {#34}────────────";
        }
        {
          type = "host";
          key = "│ Host";
          keyColor = "blue";
        }
        {
          type = "cpu";
          key = "│ CPU";
          keyColor = "blue";
        }
        {
          type = "gpu";
          key = "│ GPU";
          keyColor = "blue";
        }
        {
          type = "memory";
          key = "│ Memory";
          keyColor = "blue";
        }
        {
          type = "disk";
          key = "│ Disk";
          keyColor = "blue";
        }

        {
          type = "custom";
          format = "{#34}├───────────── {#35}Uptime {#34}─────────────";
        }
        {
          type = "uptime";
          key = "│";
          keyColor = "blue";
        }

        {
          type = "custom";
          format = "{#34}╰──────────────────────────────────";
        }
        "colors"
        {
          type = "custom";
          format = " ";
        }
        {
          type = "custom";
          format = " ";
        }
      ];
    };
  };
}
