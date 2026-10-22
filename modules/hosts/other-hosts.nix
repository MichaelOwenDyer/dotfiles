{
  inputs,
  ...
}:
{
  flake.lib.hosts = {
    phone = {
      hostName = "michaels-nothing-phone-4a";
      networks = {
        home = { ipv4 = "192.168.1.15"; interface = null; mac = "82:29:bc:59:7d:3b"; };
        tailscale = { ipv4 = "100.103.19.121"; ipv6 = "fd7a:115c:a1e0::ec01:138c"; };
      };
      keys.users.michael = {
        pub = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL3MxiYU5PIzSCwLkOklV2Ofo4l0AvR9ve61j+UnbSVKZCjthTsegWp+OBpmEOP5VLzfZAw2bIUNcej98U92jp4=";
        privateKeySecret = null; # phone, not managed by sops
        deployPath = null;
        owner = null;
      };
    };

    mr3000x = {
      hostName = "mr3000x";
      system = null;
      networks = {
        home = { ipv4 = "192.168.1.2"; interface = null; mac = "08:8a:f1:05:ec:1c"; };
      };
    };

    ax55 = {
      hostName = "ax55";
      system = null;
      networks = {
        home = { ipv4 = "192.168.1.4"; interface = null; mac = "01:9c:a2:f4:3a:66:d4"; };
      };
    };

    switch = {
      hostName = "switch";
      system = null;
      networks = {
        home = { ipv4 = "192.168.1.3"; interface = null; mac = "cc:ba:bd:07:43:1d"; };
      };
    };

    beste-s25 = {
      hostName = "bestes-s25";
      networks = {
        home = { ipv4 = "192.168.1.20"; interface = null; mac = "d6:13:66:c8:87:ba"; };
      };
    };

    idil-laptop = {
      hostName = "idils-laptop";
      networks = {
        home = { ipv4 = "192.168.1.21"; interface = null; mac = "7c:b5:66:b7:95:30"; };
      };
    };
  };
}