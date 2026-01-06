{
  ...
}:
{
  flake.modules.homeManager.mpv =
    { ... }:
    {
      programs.mpv = {
        enable = true;
        config = {
          # Use the modern GPU output driver
          "vo" = "gpu-next";
          # Enable hardware decoding (VAAPI for Intel/AMD, VDPAU for NVIDIA)
          "hwdec" = "auto";
          # Controls the quality/format of streams from sites like YouTube via yt-dlp.
          "ytdl-format" = "bestvideo[height<=?1080]+bestaudio/best[height<=?1080]";
        };
      };
    };
}
