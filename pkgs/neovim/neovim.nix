{
  pkgs,
  lib,
  wrapNeovim,
  neovim-unwrapped,
  vimPlugins,
  lua51Packages,
}: let
  inherit (lib) filterAttrs hasSuffix mapAttrsToList;
  inherit (builtins) concatStringsSep hasAttr map readDir toString;

  asLua = text: ''
    lua << EOF
    ${text}
    EOF
  '';

  /*
   Checks that a file is a regular nix file.
   Useful for functions that map onto attrsets generated from getDir.
   */
  isRegularNixFile = path: type: type == "regular" && hasSuffix ".nix" path;

  /*
   Reads a directory and filters for nix files.
   */
  getDir = dir: filterAttrs isRegularNixFile (readDir dir);

  /*
   Reads all the nix files in a directory and creates a list of file paths.
   */
  getFiles = dir: mapAttrsToList (path: type: toString dir + "/" + path) (getDir dir);

  /*
   Imports all nix files from the plugins direcotry. Output is a list of plugin attrsets.
   */
  pluginsWithConfig = map (x: import x {inherit vimPlugins;}) (getFiles ./plugins);
in
  (wrapNeovim neovim-unwrapped {}).override {
    # viAlias = true;
    # vimAlias = true;
    configure = {
      packages.myVimPackages.start = lib.flatten (map (x: x.plugins) pluginsWithConfig);

      /*
          Each plugin attrset can have a 'lua' or 'viml' attribute. lua scripts need to have the
       asLua function run on them before concatenating into the string so they work properly.
       */
      customRC = concatStringsSep "\n\n" (map (x:
        if hasAttr "lua" x
        then asLua x.lua
        else x.viml)
      pluginsWithConfig);
    };
  }
