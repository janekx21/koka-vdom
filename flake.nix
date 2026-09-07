{
  description = "koka-raylib: Koka language bindings for raylib";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Uncomment if we need a newer/specific Koka than what's in nixpkgs:
    # koka-src = {
    #   url = "github:koka-lang/koka";
    #   flake = false;
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        raylibDeps =
          with pkgs;
          lib.optionals stdenv.isLinux [
            # libGL
            # xorg.libX11
            # xorg.libXrandr
            # xorg.libXinerama
            # xorg.libXcursor
            # xorg.libXi
            # xorg.libXext
            # pkg-config
          ]
          ++ lib.optionals stdenv.isDarwin [
            # darwin.apple_sdk.frameworks.Cocoa
            # darwin.apple_sdk.frameworks.IOKit
            # darwin.apple_sdk.frameworks.CoreVideo
            # darwin.apple_sdk.frameworks.OpenGL
          ];

        # run-game = pkgs.writeShellScriptBin "run" ''
        #   koka game.kk -e \
        #     --ccopts="$(pkg-config --cflags raylib)" \
        #     --cclinkopts="$(pkg-config --libs raylib)"
        # '';
      in
      {
        devShells.default = pkgs.mkShell {
          name = "koka-raylib";

          buildInputs =
            with pkgs;
            [
              koka
              # gcc
              # pkg-config
              # raylib
              # cmake # raylib build/example tooling sometimes wants this
            ]
            ++ raylibDeps;

          # nativeBuildInputs = [ run-game ];

          shellHook = ''
            # export PKG_CONFIG_PATH="${pkgs.raylib}/lib/pkgconfig:$PKG_CONFIG_PATH"

            # Bake raylib's include/link flags into every `koka` invocation,
            # so `koka raylib.kk -e` just works without passing --ccopts/
            # --cclinkopts by hand each time. Koka reads this env var and
            # prepends it to its own argv (see `koka --help`).
            # export koka_options="--ccopts=$(pkg-config --cflags raylib) --cclinkopts=$(pkg-config --libs raylib)"
            # This does not work (koka bug) use:
            # koka raylib.kk -e \
            #   --ccopts="$(pkg-config --cflags raylib)" \
            #   --cclinkopts="$(pkg-config --libs raylib)"            

            # echo "koka-raylib dev shell"
            # echo "  koka:   $(koka --version 2>/dev/null || echo 'not found')"
            # echo "  raylib: ${pkgs.raylib.version}"
          '';
        };

        # Placeholder for later: `nix build` to produce the compiled binding/examples.
        # packages.default = pkgs.stdenv.mkDerivation { ... };
      }
    );
}
