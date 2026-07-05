{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  libGL,
  wayland,
  wayland-protocols,
  libinput,
  libxkbcommon,
  pixman,
  libcap,
  libgbm,
  libxcb-wm,
  libxcb-render-util,
  libxcb-image,
  libxcb-errors,
  libx11,
  hwdata,
  seatd,
  vulkan-loader,
  glslang,
  libliftoff,
  libdisplay-info,
  lcms2,
  evdev-proto,

  enableXWayland ? true,
  xwayland ? null,
  version ? "git",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wlroots";
  inherit version;

  inherit enableXWayland;

  src = ./.;

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    glslang
    hwdata
  ];

  propagatedBuildInputs = [
    libinput
  ];

  buildInputs = [
    libliftoff
    libdisplay-info
    libGL
    libxkbcommon
    libgbm
    pixman
    seatd
    vulkan-loader
    wayland
    wayland-protocols
    libx11
    libxcb-errors
    libxcb-image
    libxcb-render-util
    libxcb-wm
    lcms2
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libcap
  ++ lib.optional stdenv.hostPlatform.isFreeBSD evdev-proto
  ++ lib.optional finalAttrs.enableXWayland xwayland;

  mesonFlags = [
    (lib.mesonEnable "xwayland" finalAttrs.enableXWayland)
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    (lib.mesonOption "allocators" "gbm")
  ];

  meta = {
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    pkgConfigModules = [
      (
        if lib.versionOlder finalAttrs.version "0.18" then
          "wlroots"
        else
          "wlroots-${lib.versions.majorMinor finalAttrs.version}"
      )
    ];
  };
})
