{
  description = "OSS Elixir projects development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
    elixir-overlay.url = "github:zoedsoupe/elixir-overlay";
  };

  outputs = {nixpkgs, elixir-overlay, ...}: {
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [elixir-overlay.overlays.default];
      };
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          erlang_28
          (elixir-with-otp erlang_28).latest
          just
        ] ++ pkgs.lib.optional pkgs.stdenv.isLinux inotify-tools;
      };
    });
  };
}
