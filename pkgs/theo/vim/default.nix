{ pkgs ? (import ../globals.nix).pinnedPkgs {}}:

let
	vimrcBootstrap = pkgs.writeText "vimrcBootstrap" "source $THEO_VIMRC";
	dotfiles = (import ../theo-dotfiles) {};
in
pkgs.stdenv.mkDerivation rec {
	pname = "theo-vim";
	version = "0.1.0";
	outputs = [ "out" "share" ];

	phases = ["installPhase"];


	inherit dotfiles vimrcBootstrap;
	buildInputs = [ pkgs.makeWrapper ];

	installPhase = ''
		mkdir $share

		cp -a $dotfiles/vim/.vimrc $share

		mkdir $out
		# Link everything from vim 
		ln -s ${pkgs.vim}/* $out

		# Except bin, so we can create a wrapped vim bin.
		rm $out/bin && mkdir $out/bin
		ln -s ${pkgs.vim}/bin/* $out/bin

		# Make the wrapped bin vim, linking the bootstrap vimrc file
		# and setting the env variable pointing to our actual .vimrc file.
		rm $out/bin/vim
		makeWrapper ${pkgs.vim}/bin/vim $out/bin/vim \
			--run "ln -sf $vimrcBootstrap \$HOME/.vimrc" \
			--set THEO_VIMRC $share/.vimrc
	'';
}

