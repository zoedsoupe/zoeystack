{
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
          # Elixir/Erlang
          erlang_28
          (elixir-with-otp erlang_28).latest

          # Ruby
          ruby_3_2
          sqlite
          libyaml
          zlib
          pkg-config

          # Node/Bun
          bun

          # Python tooling
          uv

          # Common tools
          git
        ];

        shellHook = ''
          # Ruby/Bundler setup
          export GEM_HOME=$PWD/.gem
          export GEM_PATH=$GEM_HOME
          export PATH=$GEM_HOME/bin:$PATH
          export BUNDLE_PATH=$GEM_HOME

          if [ ! -f "$GEM_HOME/gems/bundler-2.6.6/lib/bundler.rb" ]; then
            gem install bundler -v 2.6.6 --no-document
          fi
        '';
      };
    });
  };
}
