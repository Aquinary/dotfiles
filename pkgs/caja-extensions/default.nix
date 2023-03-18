{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, makeWrapper ? pkgs.makeWrapper
, caja-extensions ? pkgs.mate.caja-extensions
, caja ? pkgs.mate.caja
, engrampa ? pkgs.mate.engrampa
, extensions ? [ caja-extensions engrampa  ]
, mateUpdateScript ? pkgs.mateUpdateScript
}:

stdenv.mkDerivation {
  pname = "${caja.pname}-with-extensions";
  version = caja.version;
  src = caja.src;

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  inherit caja;

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper $caja/bin/caja $out/bin/caja \
    --set CAJA_EXTENSION_DIRS ${lib.concatMapStringsSep ":" (x: "${x.outPath}/lib/caja/extensions-2.0") extensions}

    runHook postInstall
  '';

  postInstall = ''
     mkdir -p $out/share/applications

    for file in `find $caja/share/ -type f -name "*"`
    do
      pathToFile=$(echo $file | awk -F "/" 'OFS = "/" {$2=$3=$4=""; print substr($0, 5)}')
      pathToDir=$(echo $pathToFile | awk -F "/" 'OFS = "/" {$NF=""; print $0}')
      
      mkdir -p $out/$pathToDir

      cat $caja/$pathToFile > $out/$pathToFile
      sed -i "s|$caja|$out|gi" "$out/$pathToFile"
    done
  '';
  inherit (caja.meta);
}