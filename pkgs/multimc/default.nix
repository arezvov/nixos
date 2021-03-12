{ stdenv, fetchFromGitHub, cmake, jdk8, zlib, file, makeWrapper, xorg, libpulseaudio, qtbase, fetchurl }:

let
  jdk = jdk8;
  libpath = with xorg; stdenv.lib.makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio ];
in stdenv.mkDerivation rec {
  pname = "multimc";
  version = "0.6.11";

  src = fetchurl {
    url = "https://github.com/AfoninZ/MultiMC5-Cracked/archive/0.6.11.tar.gz";
    sha256 = "0n2fpn8igcj168pjax8m0ab8bx3zim0q98xb4hh3bprw3b6knr1v";
  };

  nativeBuildInputs = [ cmake file makeWrapper ];
  buildInputs = [ qtbase jdk zlib ];

  enableParallelBuilding = true;

  cmakeFlags = [ "-DMultiMC_LAYOUT=lin-system" ];

  postInstall = ''
    install -Dm644 ../application/resources/multimc/scalable/multimc.svg $out/share/pixmaps/multimc.svg
    install -Dm755 ../application/package/linux/multimc.desktop $out/share/applications/multimc.desktop
    # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
    wrapProgram $out/bin/multimc --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${libpath} --prefix PATH : ${jdk}/bin/:${xorg.xrandr}/bin/
  '';

  meta = with stdenv.lib; {
    homepage = "https://multimc.org/";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with their own mods, texture packs, saves, etc) and helps you manage them and their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.cleverca22 ];
  };
}
