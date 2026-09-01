{
  description = "circuitjs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
        name = "circuitjs";
        version = "2026.08.02";
        src = pkgs.fetchurl {
          url = "https://www.falstad.com/circuit/offline/circuitjs1-linux64.tgz";
          hash = "sha256-oVH+LVSggGKtaIkVZK05Ctyf7euLTlsQzSOY6cfX3HE=";
        };

        buildInputs = [ pkgs.makeWrapper ];

        buildPhase =
          let
            libPath = pkgs.lib.makeLibraryPath [
              pkgs.nss
              pkgs.glib
              pkgs.atk
              pkgs.cups
              pkgs.dbus
              pkgs.libdrm
              pkgs.gtk3
              pkgs.pango
              pkgs.cairo
              pkgs.libxcomposite
              pkgs.libxdamage
              pkgs.libxfixes
              pkgs.libxrandr
              pkgs.libgbm
              pkgs.expat
              pkgs.libxcb
              pkgs.alsa-lib
              pkgs.libGL
              pkgs.nspr
              pkgs.libx11
              pkgs.libxext
              pkgs.libxkbcommon
            ];
          in
          ''
            mkdir -p $out/bin
            cp * $out/bin -r
            mv $out/bin/circuitjs1 $out/bin/circuitjs1-real
            makeWrapper "$out/bin/circuitjs1-real" "$out/bin/circuitjs1" --set LD_LIBRARY_PATH "${libPath}"
          '';
      };
    };
}
