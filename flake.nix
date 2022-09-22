{
  description = "Patch fonts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs {inherit system;};
        python-fontforge = pkgs.python3.withPackages(p: with p; [
          python-fontforge
        ]);
        patch = pkgs.writeShellApplication {
          name = "patch";
          text = ''
            mkdir -p ./pragmata/patched
            for FILE in ./pragmata/PragmataPro0.829/*.ttf; do
                echo "$FILE"
                fontforge -script font-patcher "$FILE" -c --careful -out ./pragmata/patched
            done;
          '';
          runtimeInputs = [ python-fontforge pkgs.fontforge ];
        };
    in {
      packages.default = patch;
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs;
          [
            unzip
            zip
            patch
          ];
      };
    });
}
