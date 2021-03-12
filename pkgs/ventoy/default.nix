{ stdenv, fetchurl, ... }:

stdenv.mkDerivation rec {
  pname = "ventoy";
  version = "1.0.37";

  src = fetchurl {
    url = "https://github.com/ventoy/Ventoy/releases/download/v${version}/${pname}-${version}-linux.tar.gz";
    sha256 = "2f98780679299b1c3677ad127e6e99ffa08711b4a8d64cb0a07843a156fae83b";
  };
  buildPhase = ''
    ls -alh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out/bin
  '';
}
