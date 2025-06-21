{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # System monitoring tools
    btop # Interactive process viewer
    nvitop # NVIDIA GPU monitoring tool
    glances # System monitoring tool
    iotop # Monitor disk I/O
    nload # Network traffic monitor
    iftop # Network bandwidth usage
    vnstat # Network traffic monitor
    sysstat # Collection of performance monitoring tools
    dool # Versatile resource monitoring tool
    prometheus-nvidia-gpu-exporter # Export NVIDIA GPU metrics for Prometheus
  ];

  services.prometheus = {
    enable = true; # Enable Prometheus for system monitoring
    exporters = {
      node.enable = true; # Enable Node Exporter for system metrics
      nvidia-gpu.enable = true; # Enable NVIDIA GPU exporter
    };
  };

  services.grafana = {
    enable = true; # Enable Grafana for visualizing metrics
    settings = {
      server = {
        enable_gzip = true;
      };
    };
  };
  
  systemd.services.system-monitor = {
    description = "System Monitoring Service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.glances}/bin/glances -w"; # Start Glances in web mode
      Restart = "always";
      RestartSec = 10;
    };
  };
}