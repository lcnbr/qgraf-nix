{
  lib,
  stdenv,
  fetchurl,
  gfortran,
}:
stdenv.mkDerivation rec {
  pname = "qgraf";
  version = "3.4.2";

  src = fetchurl {
    url = "https://gosam.hepforge.org/gosam-installer/qgraf-${version}.tgz";
    sha256 = lib.fakeSha256; # replace with the real hash
  };

  nativeBuildInputs = [gfortran];

  sourceRoot = ".";

  buildPhase = ''
    runHook preBuild

    qgraf_f="$(find . -maxdepth 3 -type f \( -name 'qgraf-*.f' -o -name 'qgraf*.f' \) | head -n1)"
    if [ -z "$qgraf_f" ]; then
      echo "ERROR: could not find qgraf Fortran source"
      find . -maxdepth 4 -type f
      exit 1
    fi

    gfortran -O2 "$qgraf_f" -o qgraf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 qgraf "$out/bin/qgraf"
    runHook postInstall
  '';

  meta = with lib; {
    description = "QGRAF: generator of Feynman diagrams (symbolic output)";
    homepage = "https://qchs7.ist.utl.pt/~paulo/d.html";
    mainProgram = "qgraf";
    platforms = platforms.unix;
    # If you want strict policy compliance, you may need to revisit this.
    license = licenses.unfreeRedistributable;
  };
}
