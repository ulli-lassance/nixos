{ config, ... }:

{
  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
        "display": {
            "separator": "› "
        },
        "modules": [
            {
                "type": "custom",
                "format": "\u001b[34m╭──────────── \u001b[35mSoftware \u001b[34m────────────"
            },
            {
                "type": "os",
                "key": "│ OS",
                "keyColor": "blue"
            },
            {
                "type": "kernel",
                "key": "│ Kernel",
                "keyColor": "blue"
            },
            {
                "type": "packages",
                "key": "│ Packages",
                "keyColor": "blue"
            },
            {
                "type": "shell",
                "key": "│ Shell",
                "keyColor": "blue"
            },
            {
                "type": "de",
                "key": "│ DE",
                "keyColor": "blue"
            },
            {
                "type": "terminal",
                "key": "│ Terminal",
                "keyColor": "blue"
            },
            {
                "type": "localip",
                "key": "│ Local IP",
                "keyColor": "blue"
            },
            {
                "type": "custom",
                "format": "\u001b[34m├──────────── \u001b[35mHardware \u001b[34m────────────"
            },
            {
                "type": "host",
                "key": "│ Host",
                "keyColor": "blue"
            },
            {
                "type": "cpu",
                "key": "│ CPU",
                "keyColor": "blue"
            },
            {
                "type": "gpu",
                "key": "│ GPU",
                "keyColor": "blue"
            },
            {
                "type": "memory",
                "key": "│ Memory",
                "keyColor": "blue"
            },
            {
                "type": "disk",
                "key": "│ Disk",
                "keyColor": "blue"
            },
            {
                "type": "custom",
                "format": "\u001b[34m├───────────── \u001b[35mUptime \u001b[34m─────────────"
            },
            {
                "type": "uptime",
                "key": "│",
                "keyColor": "blue"
            },
            {
                "type": "custom",
                "format": "\u001b[34m╰──────────────────────────────────"
            },
            "colors",
            {
                "type": "custom",
                "format": " "
            },
            {
                "type": "custom",
                "format": " "
            } 
        ]
    }
  '';
}

