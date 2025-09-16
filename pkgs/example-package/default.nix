{ stdenv }:

stdenv.mkDerivation rec {
  pname = "example-package";
  version = "1.0";
  src = ./.;
  buildPhase = "echo '#!/bin/sh\necho Hello World' > example";
  installPhase = "install -Dm755 example $out/bin/${pname}";
}
