{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      shortRev = self.shortRev or self.dirtyShortRev or "unknown";
      overlays = import ./overlay.nix { inherit shortRev; };

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f (
            import nixpkgs {
              inherit system;
              overlays = [ overlays.default ];
            }
          )
        );
    in
    {
      inherit overlays;

      packages = forAllSystems (pkgs: {
        wlroots = pkgs.wlroots;
        default = pkgs.wlroots;
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            meson
            ninja
            pkg-config
            wayland-scanner
            libGL
            wayland
            wayland-protocols
            libinput
            libxkbcommon
            pixman
            libcap
            libgbm
            libxcb-wm
            libxcb-render-util
            libxcb-image
            libxcb-errors
            libx11
            hwdata
            seatd
            vulkan-loader
            glslang
            libliftoff
            libdisplay-info
            lcms2
          ];
        };
      });
    };
}
