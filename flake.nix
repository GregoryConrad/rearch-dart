{
  description = "ReArch for Dart";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            flutter335
          ];

          shellHook = ''
            if ! dart pub global list | grep -q melos; then
              dart pub global activate melos
            fi
            export PATH="$PATH":"$HOME/.pub-cache/bin"
          '';
        };
      }
    );
}
