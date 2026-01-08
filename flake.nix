{
  description = "My Development Environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = { self, nixpkgs }: {
    devShells.default = nixpkgs.mkShell {
      buildInputs = [
        nixpkgs.neovim
        nixpkgs.git
        nixpkgs.gnumake
        nixpkgs.unzip
        nixpkgs.ripgrep
        nixpkgs.fd
	nixpkgs.eza    # Add eza
        nixpkgs.yazi   # Add yazi
	nixpkgs.fzf
	nixpkgs.bat
	nixpkgs.lolcat # Add eza
      ];

      shellHook = ''
        export XDG_CONFIG_HOME="$PWD/.config/nvim"
        export XDG_DATA_HOME="$PWD/.local/share/nvim"
        export XDG_STATE_HOME="$PWD/.local/state/nvim"
      '';
    };
  };
}

