{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";

  outputs = {nixpkgs, ...}: {
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          bun
          typescript
          just
        ] ++ pkgs.lib.optional pkgs.stdenv.isLinux inotify-tools;
      };
    });
  };
}
