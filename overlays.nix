inputs:

[
  # Make stable nixpkgs accessible via 'pkgs.stable'
  (final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = final.config.allowUnfree;
    };
  })
  # NUR overlay makes packages accessible under 'pkgs.nur'
  inputs.nur.overlays.default
]
