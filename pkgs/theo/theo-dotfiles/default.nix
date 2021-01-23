let
	pinnedPkgs = (import ../globals.nix).pinnedPkgs;
in
{ pkgs ? pinnedPkgs {}
}:
pkgs.stdenv.mkDerivation {
  pname = "theo-dotfiles";
  version = "0.1.0";
  
  src = builtins.fetchGit {
    url = "https://github.com/theosherry/dotfiles";
    rev = "689c95faf071a3dad8e8bad6fa09632feadb2002";
  };
  
  installPhase = ''
	mkdir $out
    cp -a $src/* $out
  '';
}
