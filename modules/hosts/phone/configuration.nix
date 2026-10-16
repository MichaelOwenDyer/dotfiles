{
  inputs,
  ...
}:
{
  flake.lib.keys.ssh.user = {
    "michael@phone" = {
      pub = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL3MxiYU5PIzSCwLkOklV2Ofo4l0AvR9ve61j+UnbSVKZCjthTsegWp+OBpmEOP5VLzfZAw2bIUNcej98U92jp4=";
      privateKeySecret = null; # phone, not managed by sops
      deployPath = null;
      owner = null;
    };
  };
}