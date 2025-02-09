{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "monolisa";
  version = "2.017";
  src = ./.;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -r $src/*.{ttf,otf} $out/share/fonts/truetype/
  '';
}
