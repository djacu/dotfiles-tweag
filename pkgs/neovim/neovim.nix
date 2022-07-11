{
  pkgs,
  lib,
  wrapNeovim,
  neovim-unwrapped,
  vimPlugins,
  lua51Packages,
}: let
  inherit (lib) filterAttrs hasSuffix mapAttrsToList;
  inherit (builtins) concatStringsSep elem hasAttr map readDir toString;

  asLua = text: ''
    lua << EOF
    ${text}
    EOF
  '';

  blacklist = [
    "coq.nix"
  ];

  /*
   Checks that a file is a regular nix file.
   Useful for functions that map onto attrsets generated from readDir.
   */
  isRegularNixFile = path: type:
    (type == "regular")
    && (hasSuffix ".nix" path)
    && !(elem path blacklist);

  /*
   Returns an attrset of all nix files of a given directory.
   */
  readNixFilesInDir = dir: filterAttrs isRegularNixFile (readDir dir);

  /*
   Return the contents of a directory as an list given a function that
   reads a directory, `read`, and a directory, `dir`.
   */
  getFiles = read: dir: mapAttrsToList (path: type: toString dir + "/" + path) (read dir);

  /*
   Returns a list of all nix files of a given directory.
   */
  getNixFiles = getFiles readNixFilesInDir;

  /*
   Imports all nix files from the plugins direcotry. Output is a list of plugin attrsets.
   */
  pluginsWithConfig = map (x: import x {inherit vimPlugins;}) (getNixFiles ./plugins);
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
