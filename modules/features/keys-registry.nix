{ ... }:
{
  # Cryptographic Keys Registry
  # Private keys in sops, deployed via keys-deployment module.
  # Age keys (derived from SSH) managed in .sops.yaml

  flake.lib.keys = {
    ssh.user = {
      "michael@claptrap" = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtKFTvyCJo4u7KstzHIZ/ZdBCfS5ukmItX75tC0aM5O michael@claptrap";
        privateKeySecret = "ssh-michael-claptrap";
        deployPath = "/home/michael/.ssh/id_ed25519";
        owner = "michael";
      };
      "michael@rustbucket" = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvS0a2EKa9kxQ1DK3JMS6UVYOXnOvlTFQzukp9U/M4n michael@rustbucket";
        privateKeySecret = "ssh-michael-rustbucket";
        deployPath = "/home/michael/.ssh/id_ed25519";
        owner = "michael";
      };
      "michael@rpi-3b" = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1RmSKMqa9vAqyHjJzEmjFOJYV+qT/imHpXDmeWl6PI michael@rpi-3b";
        privateKeySecret = "ssh-michael-rpi-3b";
        deployPath = "/home/michael/.ssh/id_ed25519";
        owner = "michael";
      };
      "michael@mac" = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaQ4EQjxoG3L5kMu5wK1eE1w6V4y1lw3/ynJfd/0Nis michael.dyer@JGFQQXM192";
        privateKeySecret = null; # macOS, not managed by sops
        deployPath = "/Users/michael/.ssh/id_ed25519";
        owner = "michael";
      };
      "michael@phone" = {
        pub = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL3MxiYU5PIzSCwLkOklV2Ofo4l0AvR9ve61j+UnbSVKZCjthTsegWp+OBpmEOP5VLzfZAw2bIUNcej98U92jp4=";
        privateKeySecret = null; # phone, not managed by sops
        deployPath = null;
        owner = null;
      };
    };

    # Root keys for distributed builds (build clients only)
    ssh.root = {
      "root@claptrap" = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQ0T01LHYpwEHrUPz7MAzVAj0QPP2BDyiKdSlL38Yp8 root@claptrap";
        privateKeySecret = "ssh-root-claptrap";
        deployPath = "/root/.ssh/nixremote";
        owner = "root";
      };
      "root@rpi-3b" = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPQY1jga8pE59ErPEGTt5Rz0GjwGKJq8svjeWWnqeSc root@rpi-3b";
        privateKeySecret = "ssh-root-rpi-3b";
        deployPath = "/root/.ssh/nixremote";
        owner = "root";
      };
    };

    # Host keys - bootstrap trust anchor, NOT in sops (used to decrypt sops)
    # Derive age key: ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
    ssh.host = {
      rustbucket = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGw0ssMwpvMC+mVlHIrRnYaIV+oCaRj6jiyxL9wu1Mr7 root@rustbucket";
        path = "/etc/ssh/ssh_host_ed25519_key";
        persistPath = "/persist/etc/ssh/ssh_host_ed25519_key";
      };
      claptrap = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMp1vwRlPjCkZRyN6Tgc0FD9mwKsAFPCjslVPe26M5nG root@claptrap";
        path = "/etc/ssh/ssh_host_ed25519_key";
        persistPath = "/persist/etc/ssh/ssh_host_ed25519_key";
      };
      rpi-3b = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG69KLqwVXfDt4LF1E9v8tL8jlJbdqt+1MpT7J7M0i8r root@rpi-3b";
        path = "/etc/ssh/ssh_host_ed25519_key";
        persistPath = null; # no impermanence
      };
    };

    # Binary cache signing keys
    signing = {
      rustbucket = {
        pub = "rustbucket-1:AMe1QbSNHWw+Cyau5rwhAxknUDtmb49vY8tyIbOVAn0=";
        privateKeySecret = "nix-signing-rustbucket";
        deployPath = "/etc/nix/cache-priv-key.pem";
        owner = "root";
      };
    };
  };

  # Legacy compatibility - TODO: migrate usages to keys.ssh.* and remove
  flake.lib.sshKeys = {
    "michael@claptrap" = { pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtKFTvyCJo4u7KstzHIZ/ZdBCfS5ukmItX75tC0aM5O michael@claptrap"; privatePath = "/home/michael/.ssh/id_ed25519"; };
    "michael@rustbucket" = { pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvS0a2EKa9kxQ1DK3JMS6UVYOXnOvlTFQzukp9U/M4n michael@rustbucket"; privatePath = "/home/michael/.ssh/id_ed25519"; };
    "michael@rpi-3b" = { pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1RmSKMqa9vAqyHjJzEmjFOJYV+qT/imHpXDmeWl6PI michael@rpi-3b"; privatePath = "/home/michael/.ssh/id_ed25519"; };
    "michael@mac" = { pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaQ4EQjxoG3L5kMu5wK1eE1w6V4y1lw3/ynJfd/0Nis michael.dyer@JGFQQXM192"; privatePath = "/Users/michael/.ssh/id_ed25519"; };
    "root@claptrap" = { pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQ0T01LHYpwEHrUPz7MAzVAj0QPP2BDyiKdSlL38Yp8 root@claptrap"; privatePath = "/root/.ssh/nixremote"; };
    "root@rpi-3b" = { pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPQY1jga8pE59ErPEGTt5Rz0GjwGKJq8svjeWWnqeSc root@rpi-3b"; privatePath = "/root/.ssh/nixremote"; };
    "michael@phone" = { pub = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL3MxiYU5PIzSCwLkOklV2Ofo4l0AvR9ve61j+UnbSVKZCjthTsegWp+OBpmEOP5VLzfZAw2bIUNcej98U92jp4="; };
  };
}
