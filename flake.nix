{
  description = "VS-RIFE CUDA-accelerated with mpv";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/pull/182585/head";
    flake-utils.url = "github:numtide/flake-utils";
    vs-overlay.url = "github:volodiapg/vs-overlay";
  };

  outputs = { self, flake-utils, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system: # leverage flake-utils
      let
        overlay = final: prev: {
          # vapoursynth = prev.vapoursynth.withPlugins [
          #   # self.packages.${system}.vs-rife-vulkan
          # ];
          # mpv-unwrapped = prev.mpv-unwrapped.override {
          #   vapoursynthSupport = true;
          #   vapoursynth = prev.vapoursynth.withPlugins [
          #     inputs.vs-overlay.packages.x86_64-linux.vapoursynthPlugins.vsutil
          #     inputs.vs-overlay.packages.x86_64-linux.vapoursynthPlugins.vsrife
          #     # pkgs.vapoursynthPlugins.mvtools
          #     # pkgs.vapoursynthPlugins.vsrife
          #   ];
          # };
          # mpv = final.wrapMpv final.mpv-unwrapped { youtubeSupport = true; };
          glslang = prev.glslang.overrideAttrs (oldAttrs: rec {
            # This is a dirty fix for lib/cmake/SPIRVTargets.cmake:51 which includes this directory
            postInstall = ''
              mkdir $out/include/External
            '';
          });
          # ncnn = prev.ncnn.overrideAttrs (oldAttrs: rec {
          #   version = "20220216";
          #   src = prev.fetchFromGitHub {
          #     owner = "Tencent";
          #     repo = oldAttrs.pname;
          #     rev = version;
          #     sha256 = "sha256-QHLD5NQZA7WR4mRQ0NIaXuAu59IV4SjXHOOlar5aOew";
          #   };

          #   patches = oldAttrs.patches ++ [
          #     ./gpu-include-ncnn.patch
          #   ];
          # });
        };
        pkgs = import nixpkgs {
          inherit system;
          # config = {
          #   allowUnfree = true;
          # };
          # overlays = [ inputs.vs-overlay.overlay overlay ];
          overlays = [ overlay ];
        };
      in
      {
        packages = rec {
          vs-rife-vulkan = pkgs.callPackage ./vs-rife-vulkan { };
          default = vs-rife-vulkan;
        };
        devShell = pkgs.mkShell
          {
            buildInputs = with pkgs;
              [
                meson
                cmake
                ninja
                pkg-config
                spirv-headers
                vulkan-headers
                spirv-tools
                vulkan-loader
                vulkan-tools
                # glslang
                # vulkan-validation-layers
                ncnn
                vapoursynth
                # meson
                # pkg-config
                # cmake
                # ninja
                # glslang
                # vulkan-headers
                # vulkan-loader
                # vulkan-validation-layers
                # vapoursynth
                # (vapoursynth.withPlugins [
                #   vapoursynthPlugins.mvtools
                #   vapoursynthPlugins.vsrife
                # ])
                # (vapoursynth.withPlugins [
                #   inputs.vs-overlay.packages.x86_64-linux.vapoursynthPlugins.vsutil
                #   inputs.vs-overlay.packages.x86_64-linux.vapoursynthPlugins.vsrife
                # ])
                # (vapoursynth-editor.withPlugins [
                #   inputs.vs-overlay.packages.x86_64-linux.vapoursynthPlugins.vsutil
                #   inputs.vs-overlay.packages.x86_64-linux.vapoursynthPlugins.vsrife
                # ])
                # mpv
                (wrapMpv
                  (mpv-unwrapped.override
                    {
                      vapoursynthSupport = true;
                      # vapoursynth = vapoursynth.withPlugins [
                      #   self.packages.${system}.vs-rife-vulkan
                      # ];
                    })
                  { })
              ];

            LIBRIFE = "${self.packages.${system}.vs-rife-vulkan}/lib/vapoursynth/librife.so";

            inputsFrom = builtins.attrValues self.packages.${system};
          };
      });
}
