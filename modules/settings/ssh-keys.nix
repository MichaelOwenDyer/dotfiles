{
  ...
}:
{
  # Central registry for SSH keys
  # Reference: inputs.self.lib.sshKeys."<user>@<host>".<pub|privatePath>

  flake.lib.sshKeys = {
    "michael@claptrap" = {
      pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtKFTvyCJo4u7KstzHIZ/ZdBCfS5ukmItX75tC0aM5O michael@claptrap";
      privatePath = "/home/michael/.ssh/id_ed25519";
    };
    "michael@rustbucket" = {
      pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvS0a2EKa9kxQ1DK3JMS6UVYOXnOvlTFQzukp9U/M4n michael@rustbucket";
      privatePath = "/home/michael/.ssh/id_ed25519";
    };
    "michael@rpi-3b" = {
      pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1RmSKMqa9vAqyHjJzEmjFOJYV+qT/imHpXDmeWl6PI michael@rpi-3b";
      privatePath = "/home/michael/.ssh/id_ed25519";
    };
    "michael@mac" = {
      pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaQ4EQjxoG3L5kMu5wK1eE1w6V4y1lw3/ynJfd/0Nis michael.dyer@JGFQQXM192";
      privatePath = "/Users/michael/.ssh/id_ed25519";
    };
    "root@claptrap" = {
      pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQ0T01LHYpwEHrUPz7MAzVAj0QPP2BDyiKdSlL38Yp8 root@claptrap";
      privatePath = "/root/.ssh/nixremote";
    };
    "root@rpi-3b" = {
      pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPQY1jga8pE59ErPEGTt5Rz0GjwGKJq8svjeWWnqeSc root@rpi-3b";
      privatePath = "/root/.ssh/nixremote";
    };
  };
}
