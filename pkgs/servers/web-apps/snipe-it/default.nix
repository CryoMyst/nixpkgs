{ pkgs, stdenv, lib, fetchFromGitHub, dataDir ? "/var/lib/snipe-it" }:

let
  package = (import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    noDev = true; # Disable development dependencies
  }).overrideAttrs (attrs : {
    installPhase = attrs.installPhase + ''
      rm -R $out/storage $out/public/uploads $out/bootstrap/cache
      ln -s ${dataDir}/.env $out/.env
      ln -s ${dataDir}/storage $out/
      ln -s ${dataDir}/public/uploads $out/public/uploads
      ln -s ${dataDir}/bootstrap/cache $out/bootstrap/cache
      chmod +x $out/artisan
    '';
  });

in package.override rec {
  pname = "snipe-it";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "snipe";
    repo = pname;
    rev = "v${version}";
    sha256 = "174s2h3whim98d9h8l4qr3vpk199zfxgwyys3d3gblpx1m5mr07k";
  };

  meta = with lib; {
    description = "A free open source IT asset/license management system ";
    longDescription = ''
      Snipe-IT was made for IT asset management, to enable IT departments to track
      who has which laptop, when it was purchased, which software licenses and accessories
      are available, and so on.
      Details for snipe-it can be found on the official website at https://snipeitapp.com/.
    '';
    homepage = "https://snipeitapp.com/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ yayayayaka ];
    platforms = platforms.linux;
  };
}
