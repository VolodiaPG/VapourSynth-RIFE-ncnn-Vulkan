{ lib
, stdenv
, fetchFromGitHub
, meson
, pkg-config
, cmake
, ninja
, vulkan-headers
, vulkan-loader
, vapoursynth
, ncnn
, ...
}:
stdenv.mkDerivation rec {
  name = "VapourSynth-RIFE-ncnn-Vulkan-${version}";
  version = "r9";
  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-RIFE-ncnn-Vulkan";
    rev = version;
    sha256 = "sha256-RNvLVyaGOAdcASur8AGl1t0tgRdxxBlZl/wAI9XNENM=";
  };

  patches = [ ./fix_lib_path.patch ];

  nativeBuildInputs = [
    meson
    cmake
    ninja
    vulkan-headers
    pkg-config
  ];

  buildInputs = [
    vulkan-loader
    ncnn
    vapoursynth
  ];

  mesonFlags = [
    "--buildtype=release"
    "-Duse_system_ncnn=true"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/ExpidusOS/libtokyo";
    license = with licenses; [ mit ];
    maintainers = [ "VolodiaPG" ];
  };
}
