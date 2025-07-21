inputs:

[
  # Make stable nixpkgs accessible via 'pkgs.stable'
  (final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = final.config.allowUnfree;
    };
    master = import inputs.nixpkgs-master {
      system = final.system;
      config.allowUnfree = final.config.allowUnfree;
    };
    zen-browser = inputs.zen-browser.packages.${final.system};
  })
  # NUR overlay makes packages accessible under 'pkgs.nur'
  inputs.nur.overlays.default
  # nh overlay makes nh accessible under 'pkgs.nh'
  inputs.nh.overlays.default
]
