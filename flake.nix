{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      apps.${system}.watch = {
        type = "app";
        program = "${pkgs.writeShellScript "watch" ''
          ${pkgs.typst}/bin/typst watch --features bundle,html --format bundle main.typ dist
        ''}";
      };
    };
}
