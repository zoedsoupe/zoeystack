{
  description = "Elixir + Node.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
    beam-overlay.url = "github:zeeetech/beam-overlay";
  };

  outputs = {
    nixpkgs,
    beam-overlay,
    ...
  }: {
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [beam-overlay.overlays.default];
      };
    in {
      default = pkgs.mkShell {
        packages = with pkgs;
          [
            erlang_28
            (pkgs.beam-overlay.mkToolchain {
              elixir.version = "latest";
            })
            nodejs
            just
          ]
          ++ pkgs.lib.optional pkgs.stdenv.isLinux inotify-tools;
      };
    });
  };
}
