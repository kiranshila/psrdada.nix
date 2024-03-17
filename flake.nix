{
  description = "PSRDADA in a Nix flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Setup nixpkgs
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        # Build PSRDADA
        psrdadaDeriv = (with pkgs;
          stdenv.mkDerivation {
            pname = "psrdada";
            version = "1.0.0";
            src = fetchgit {
              url = "https://git.code.sf.net/p/psrdada/code";
              rev = "008afa70393ae2df11efba0cc8d0b95cda599c02";
              hash = "sha256-M/SMMKGBdVwd6g4J0DRuV1yi3aM5FXsr93u2XLO9VJE";
            };
            buildInputs = [ cmake ninja ];
            # Optional dependencies
            #++ [ rdma-core hwloc cudatoolkit ];
          });
      in {
        packages = {
          default = psrdadaDeriv;
          psrdada = psrdadaDeriv;
        };
      });
}
