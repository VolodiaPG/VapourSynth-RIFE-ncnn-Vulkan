{
  description = "VS-RIFE CUDA-accelerated with mpv";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/pull/182585/head";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system: # leverage flake-utils
      let
        pkgs = import nixpkgs {
          inherit system;
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
                (wrapMpv
                  (mpv-unwrapped.override
                    {
                      vapoursynthSupport = true;
                    })
                  { })
              ];

            LIBRIFE = "${self.packages.${system}.vs-rife-vulkan}/lib/vapoursynth/librife.so";

            inputsFrom = builtins.attrValues self.packages.${system};
          };
      });
}
