{vimPlugins}:
with vimPlugins; {
  plugins = [
    coq_nvim
  ];
  viml = ''
    let g:coq_settings = { 'xdg': v:true }
  '';
}
