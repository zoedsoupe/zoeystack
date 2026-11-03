{
  description = "Personal development shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05-small";

    beam-overlay = {
      url = "github:zeeetech/beam-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    beam-overlay,
    zig-overlay,
    ...
  }: {
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          beam-overlay.overlays.default
          zig-overlay.overlays.default
        ];
      };

      commonPackages = with pkgs;
        [just]
        ++ pkgs.lib.optional pkgs.stdenv.isLinux inotify-tools;

      mkElixirShell = {extraPackages ? []}:
        pkgs.mkShell {
          packages =
            [
              (pkgs.beam-overlay.mkToolchain {
                elixir.version = "latest";
                erlang-otp.version = "29";
              })
            ]
            ++ commonPackages
            ++ extraPackages;
        };

      shells = {
        elixir = mkElixirShell {};

        elixir-postgres = mkElixirShell {
          extraPackages = [pkgs.postgresql];
        };

        elixir-node = mkElixirShell {
          extraPackages = [pkgs.nodejs];
        };

        zig = pkgs.mkShell {
          packages = [pkgs.zigpkgs.master];
        };
      };
    in
      shells // {default = shells.elixir;});
  };
}
