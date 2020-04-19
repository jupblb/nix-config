{ stdenv, fetchFromGitHub, autoconf, automake, gettext, intltool
, libtool, pkgconfig, wrapGAppsHook, wrapPython, gobjectIntrospection
, gtk3, python, pygobject3, hicolor-icon-theme, pyxdg
, libxcb, libdrm, wayland, wayland-protocols, wlroots }:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  buildInputs = [ gobjectIntrospection gtk3 hicolor-icon-theme libxcb libdrm python wayland wayland-protocols wlroots ];

  configureFlags = [ "--enable-randr=yes" "--enable-drm=yes" "--enable-wayland=yes" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description     = "Screen color temperature manager";
    homepage        = http://jonls.dk/redshift;
    license         = licenses.gpl3Plus;
    longDescription = ''
      Redshift adjusts the color temperature according to the position
      of the sun. A different color temperature is set during night and
      daytime. During twilight and early morning, the color temperature
      transitions smoothly from night to daytime temperature to allow
      your eyes to slowly adapt. At night the color temperature should
      be set to match the lamps in your room.
    '';
    platforms       = platforms.linux;
  };
  
  name = "redshift-${version}";

  nativeBuildInputs = [ autoconf automake gettext intltool libtool pkgconfig wrapGAppsHook wrapPython ];

  patches = [ ./575.patch ];

  postFixup = "wrapPythonPrograms";

  preConfigure = "./bootstrap";

  pythonPath = [ pygobject3 pyxdg ];

  src = fetchFromGitHub {
    owner  = "minus7";
    repo   = "redshift";
    rev    = version;
    sha256 = metadata.sha256;
  };

  version = metadata.rev;
}
