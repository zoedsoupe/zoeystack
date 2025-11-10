{
  description = "Zig development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = {nixpkgs, zig-overlay, ...}: {
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [zig-overlay.overlays.default];
      };
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          zigpkgs.master
        ];
      };
    });
  };
}
