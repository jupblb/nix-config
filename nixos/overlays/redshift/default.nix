{ stdenv, fetchFromGitHub, autoconf, automake, gettext, intltool
, libtool, pkgconfig, wrapGAppsHook, wrapPython, gobjectIntrospection
, gtk3, python, pygobject3, hicolor-icon-theme, pyxdg
, libxcb, libdrm, wayland, wayland-protocols, wlroots }:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "redshift-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "minus7";
    repo = "redshift";
    rev = version;
    sha256 = metadata.sha256;
  };

  patches = [
    # https://github.com/jonls/redshift/pull/575
    ./575.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    intltool
    libtool
    pkgconfig
    wrapGAppsHook
    wrapPython
  ];

  configureFlags = [
    "--enable-randr=yes"
    "--enable-drm=yes"
    "--enable-wayland=yes"
  ];

  buildInputs = [
    gobjectIntrospection
    gtk3
    hicolor-icon-theme
    libxcb
    libdrm
    python
    wayland
    wayland-protocols
    wlroots
  ];

  pythonPath = [ pygobject3 pyxdg ];

  preConfigure = "./bootstrap";

  postFixup = "wrapPythonPrograms";

  # the geoclue agent may inspect these paths and expect them to be
  # valid without having the correct $PATH set
  postInstall = ''
    substituteInPlace $out/share/applications/redshift.desktop \
      --replace 'Exec=redshift' "Exec=$out/bin/redshift"
    substituteInPlace $out/share/applications/redshift.desktop \
      --replace 'Exec=redshift-gtk' "Exec=$out/bin/redshift-gtk"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Screen color temperature manager";
    longDescription = ''
      Redshift adjusts the color temperature according to the position
      of the sun. A different color temperature is set during night and
      daytime. During twilight and early morning, the color temperature
      transitions smoothly from night to daytime temperature to allow
      your eyes to slowly adapt. At night the color temperature should
      be set to match the lamps in your room.
    '';
    license = licenses.gpl3Plus;
    homepage = http://jonls.dk/redshift;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
