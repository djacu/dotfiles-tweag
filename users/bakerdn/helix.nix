{pkgs, ...}: let
  # Wrap helix to provide runtime dependencies
  helix = with pkgs;
    symlinkJoin {
      name = "helix";
      paths = [pkgs.helix];
      buildInputs = [makeWrapper];
      postBuild = let
        runtimeDeps =
          [
            # Lua
            sumneko-lua-language-server
            # Nickel
            nickel
            # Nix
            nil
            alejandra
            # Python
            python310Packages.black
            python310Packages.python-lsp-server
            # Toml
            taplo
          ]
          # JS/TS
          ++ (with nodePackages; [
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
