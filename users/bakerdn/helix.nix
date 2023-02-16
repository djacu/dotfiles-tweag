{pkgs, lib, system, nickel, ...}: let
  # Wrap helix to provide runtime dependencies
  helix =
    pkgs.symlinkJoin {
      name = "helix";
      paths = [pkgs.helix];
      buildInputs = [pkgs.makeWrapper];
      postBuild = let
        runtimeDeps =
          [
            # Lua
            pkgs.sumneko-lua-language-server
            # Nickel
            nickel.packages."${system}".nickel
            nickel.packages."${system}".lsp-nls
            # Nix
            pkgs.nil
            pkgs.alejandra
            # Python
            pkgs.python310Packages.black
            pkgs.python310Packages.python-lsp-server
            # Toml
            pkgs.taplo
          ]
          # JS/TS
          ++ (with pkgs.nodePackages; [
            vscode-langservers-extracted
            typescript-language-server
            typescript
          ]);
      in ''
        wrapProgram $out/bin/hx \
          --prefix PATH : ${lib.makeBinPath runtimeDeps}
      '';
    };
in {
  programs.helix = {
    enable = true;
    package = helix;

    settings.theme = "nord";
    settings.editor.true-color = true;
  };
}
