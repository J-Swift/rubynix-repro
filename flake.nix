{
  description = "My Rails App";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/?rev=d44d59d2b5bd694cd9d996fd8c51d03e3e9ba7f7";

    flake-utils.url = "github:numtide/flake-utils";
    ruby-nix.url = "github:inscapist/ruby-nix";

    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, bundix, ruby-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        ruby = pkgs.ruby_3_2;

        rubyNix = ruby-nix.lib pkgs;
        gemset = import ./gemset.nix;
        gemConfig = { };
      in rec {
        inherit
          (rubyNix {
            inherit gemset ruby;
            name = "my-rails-app";
            gemConfig = pkgs.defaultGemConfig // gemConfig;
          })
          env
          ;

        devShell = import ./shell.nix { inherit pkgs bundix env; };
      }
    );
}
