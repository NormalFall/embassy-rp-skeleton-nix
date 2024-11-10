{
  description = "Flake for the rp2040 on rust";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            probe-rs
            flip-link
            (rust-bin.fromRustupToolchainFile ./rust-toolchain.toml)
          ];

          shellHook = ''
            alias flash="cargo flash --chip RP2040"
          '';
        };
      }
    );
}