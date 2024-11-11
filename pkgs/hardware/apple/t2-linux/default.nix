{
  lib,
  buildLinux,
  fetchFromGitHub,
  fetchzip,
  runCommand,
  ...
} @ args: let
  version = "6.11.7";
  majorVersion = with lib; (elemAt (take 1 (splitVersion version)) 0);

  patchRepo = fetchFromGitHub {
    owner = "t2linux";
    repo = "linux-t2-patches";
    rev = "ec4545c603cf2ef315818eccce62d06ee18e5c60";
    hash = "sha256-Nm7WiLjotwk5NDrpKTgcKtyQTOUG7A88ZgtzD460qY0=";
  };

  kernel = fetchzip {
    url = "mirror://kernel/linux/kernel/v${majorVersion}.x/linux-${version}.tar.xz";
    hash = "sha256-wHWd8xfEFOTy0FkFBtn30+6816XC4uhgn0G9b40n9Co=";
  };
in
  buildLinux (args
    // {
      inherit version;

      pname = "linux-t2";
      # Snippet from nixpkgs
      modDirVersion = with lib; "${concatStringsSep "." (take 3 (splitVersion "${version}.0"))}";

      src = runCommand "patched-source" {} ''
        cp -r ${kernel} $out
        chmod -R u+w $out
        cd $out
        while read -r patch; do
          echo "Applying patch $patch";
          patch -p1 < $patch;
        done < <(find ${patchRepo} -type f -name "*.patch" | sort)
      '';

      structuredExtraConfig = with lib.kernel; {
        APPLE_BCE = module;
        APPLE_GMUX = module;
        APFS_FS = module;
        BRCMFMAC = module;
        BT_BCM = module;
        BT_HCIBCM4377 = module;
        BT_HCIUART_BCM = yes;
        BT_HCIUART = module;
        HID_APPLETB_BL = module;
        HID_APPLETB_KBD = module;
        HID_APPLE = module;
        DRM_APPLETBDRM = module;
        HID_SENSOR_ALS = module;
        SND_PCM = module;
        STAGING = yes;
      };

      kernelPatches = [];
    }
    // (args.argsOverride or {}))
