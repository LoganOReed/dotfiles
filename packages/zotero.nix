{ stdenv, fetchurl, autoPatchelfHook, makeWrapper, unzip
, gtk3, gtk2, libappindicator, libpulseaudio, nss, nspr, xorg
, glib, dbus-glib, libXt, libdbusmenu, gsettings-desktop-schemas, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "zotero-old";
  version = "5.0.96.3";

  src = fetchurl {
    url = "https://download.zotero.org/client/release/${version}/Zotero-${version}_linux-x86_64.tar.bz2";
    hash = "sha256-eqSNzmkGNopGJ7VByvUffFEPJz3WHS7b5+jgUAW/hU4="; 
  };

 nativeBuildInputs = [ autoPatchelfHook makeWrapper unzip wrapGAppsHook ];

  buildInputs = [
    gtk3
    gtk2
    libXt
    libappindicator
    libpulseaudio
    nss
    nspr
    xorg.libX11
    xorg.libXrender
    xorg.libXtst
    xorg.libXext
    xorg.libxcb
    glib
    dbus-glib 
    libdbusmenu
    gsettings-desktop-schemas
  ];

  unpackPhase = ''
    mkdir zotero
    tar xjf $src -C zotero --strip-components=1
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/zotero
    cp -r zotero/* $out/opt/zotero

    mkdir -p $out/bin
    makeWrapper $out/opt/zotero/zotero $out/bin/zotero \
      --prefix LD_LIBRARY_PATH : $out/opt/zotero:$LD_LIBRARY_PATH

    runHook postInstall
  '';

  meta = {
    description = "Reference management software";
    homepage = "https://www.zotero.org/";
    # license = stdenv.lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
