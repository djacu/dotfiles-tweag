{ ... }:

{
  programs.waybar.enable = true;
  programs.waybar.settings = {
    waybar = {
      layer = "top";
      position = "top";
      height = 40;

      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "tray" "network" "memory" "cpu" "battery" "clock" ];

      network.format-wifi = "WiFi ({signalStrength}%) {icon}";
      network.format-ethernet = "Ethernet {icon}";
      network.format-linked = "No IP";
      network.format-disconnected = "Disconnected {icon}";
      network.tooltip-format-wifi = "{essid} ({signalStrength}%) {icon}";
      network.tooltip-format-ethernet = "{ifname}  {ipaddr}/{cidr}";
      network.format-icons.wifi = [ "" "" "" ];
      network.format-icons.ethernet = [ "" ];
      network.format-icons.disconnected = [ "" ];

      memory.interval = 30;
      memory.format = "{}% ";
      memory.tooltip-format = "{used:0.1f}G/{total:0.1f}G";

      cpu.format = "{usage}% ";

      battery.format = "{capacity}% {icon}";
      battery.format-charging = "{capacity}% ";
      battery.format-plugged = "{capacity}% ";
      battery.format-alt = "{time} {icon}";
      battery.format-icons = [ "" "" "" "" "" ];
      battery.states.warning = 30;
      battery.states.critical = 15;
    };
  };
  programs.waybar.style = ./style.css;
}
