{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {nixpkgs, rust-overlay, ...}: {
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [rust-overlay.overlays.default];
      };
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          rust-bin.stable.latest.default
          cargo
          just
        ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
          pkg-config
          openssl
          webkitgtk
          gtk3
          libsoup
        ];
      };
    });
  };
}
