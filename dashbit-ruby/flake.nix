{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";

  outputs = {nixpkgs, ...}: {
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          ruby_3_2
          sqlite
          git
          libyaml
          zlib
          pkg-config
        ];

        shellHook = ''
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
