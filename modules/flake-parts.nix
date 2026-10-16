{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts"; # https://github.com/hercules-ci/flake-parts
    flake-file.url = "github:vic/flake-file"; # https://github.com/vic/flake-file
    import-tree.url = "github:vic/import-tree"; # https://github.com/vic/import-tree
  };

  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.flake-file.flakeModules.dendritic
  ];

  # Import all modules recursively with import-tree
  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)
  '';

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];
}
