{ lib
, stdenv
, fetchgit
, meson
, pkg-config
, cmake
, ninja
, glslang
, spirv-headers
, spirv-tools
, vulkan-headers
, vulkan-loader
, vulkan-tools
  # , vulkan-validation-layers
, vapoursynth
, autoPatchelfHook
, ncnn
, ...
}:
stdenv.mkDerivation rec {
  name = "VapourSynth-RIFE-ncnn-Vulkan-${version}";
  version = "r9";
  src = fetchgit {
    url = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-RIFE-ncnn-Vulkan";
    rev = version;
    # fetchSubmodules = true;
    sha256 = "sha256-X1c2Eo5QkDELMHo9tP1ue2iZu5qeLatQessfsqmSl60=";
  };

  patches = [ ./fix_lib_path.patch ];

  # VULKAN_SDK = "${vulkan-validation-layers}/share/vulkan/explicit_layer.d";
  # LD_LIBRARY_PATH="${vulkan-loader}/lib";
  passthru = {
    spirv-tools = spirv-tools;
    spirv-headers = spirv-headers;
  };
# +        include("${GLSLANG_TARGET_DIR}/SPIRV-Tools/SPIRV-ToolsTarget.cmake")
# +        include("${GLSLANG_TARGET_DIR}/SPIRV-Tools-opt/SPIRV-Tools-optTargets.cmake")
  nativeBuildInputs = [
    meson
    cmake
    ninja
    autoPatchelfHook
  ];
  buildInputs = [
    pkg-config
    spirv-headers
    vulkan-headers
    spirv-tools
    vulkan-loader
    vulkan-tools
    glslang
    # vulkan-validation-layers
    ncnn
    vapoursynth
  ];
  dontUseCmakeConfigure = true;
  mesonFlags = [
    "--buildtype=release"
    "-Duse_system_ncnn=true"
    
    # "-DGLSLANG_TARGET_DIR=${glslang}/lib/cmake"
  ];
  #  cmakeFlags = [
  #   "-DGLSLANG_INSTALL_DIR=${glslang}"
  #   # "-DSPIRV_HEADERS_INSTALL_DIR=${spirv-headers}"
  #   # "-DROBIN_HOOD_HASHING_INSTALL_DIR=${robin-hood-hashing}"
  #   # "-DBUILD_LAYER_SUPPORT_FILES=ON"
  #   # "-DPKG_CONFIG_EXECUTABLE=${pkg-config}/bin/pkg-config"
  #   # # Hide dev warnings that are useless for packaging
  #   # "-Wno-dev"
  #   "-DNCNN_CMAKE_VERBOSE=1" # Only for debugging the build
  #   "-DNCNN_SHARED_LIB=1"
  #   "-DNCNN_ENABLE_LTO=1"
  #   "-DNCNN_VULKAN=1"
  #   "-DNCNN_BUILD_EXAMPLES=0"
  #   "-DNCNN_BUILD_TOOLS=0"
  #   "-DNCNN_SYSTEM_GLSLANG=1"
  #   "-DNCNN_PYTHON=0" # Should be an attribute

  #   "-DGLSLANG_TARGET_DIR=${glslang}/lib/cmake"
  # ];


  enableParallelBuilding = true;

  postUnpack = ''
    ls -l 
  '';

  # postInstall = ''
  #   ls -lia
  #   # exit 1
  #     mkdir -p $out/lib/vapoursynth
  #     cp -r lib/* $out/lib/vapoursynth/
  # '';

  meta = with lib; {
    homepage = "https://github.com/ExpidusOS/libtokyo";
    license = with licenses; [ gpl3Only ];
    maintainers = [ "Tristan Ross" ];
  };
}
