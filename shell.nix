
let
  overlays = builtins.fetchTarball
    https://github.com/anmonteiro/nix-overlays/archive/3d2d00a7.tar.gz;
  pkgs = (import "${overlays}/sources.nix" {});
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_06;
in
  with pkgs;

  mkShell {
    buildInputs = with ocamlPackages; [
      bs-platform
      nodejs-14_x
      yarn
      merlin
      reason
      python3
      ocamlformat
      entr
      jq
    ];

    BSB_PATH =
      if stdenv.isDarwin
      then "${bs-platform}/darwin"
      else "${bs-platform}/linux";
  }

