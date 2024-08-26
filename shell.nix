{ pkgs, bundix, env, ... }:

let
  bundixcli = bundix.packages.${pkgs.system}.default;

  bundixAdd = pkgs.writeShellScriptBin "bundix_add" ''
    set -euo pipefail

    local -r gemname="''${1}"

    export BUNDLE_PATH=vendor/bundle
    bundle add "''${gemname}" --skip-install
  '';

  bundixUpdate = pkgs.writeShellScriptBin "bundix_update" ''
    set -euo pipefail

    local -r gemname="''${1}"

    export BUNDLE_PATH=vendor/bundle
    bundle lock --update="''${gemname}"
  '';

  bundixInstall = pkgs.writeShellScriptBin "bundix_install" ''
    set -euo pipefail

    export BUNDLE_PATH=vendor/bundle
    bundle lock
  '';
in
pkgs.mkShell {
  buildInputs = [
    env
    bundixcli
    bundixAdd
    bundixUpdate
    bundixInstall
  ];
}
