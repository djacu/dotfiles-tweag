{vimPlugins}:
with vimPlugins; {
  plugins = [
  ];
  viml = ''
    " Use <Space> as the leader key
    let mapleader=" "

    " Intuit the indentation of new lines when creating them
    set smartindent

    " Use absolute line numbers
    set number

    " Use a color column on the 80-character mark
    set colorcolumn=80

    " Press <tab>, get two spaces
    set expandtab shiftwidth=2
    " Show `▸▸` for tabs: 	, `·` for tailing whitespace:
    set list listchars=tab:▸▸,trail:·

    " Enable mouse support
    set mouse=a

    " Time in milliseconds to wait for a key code sequence to complete.
    set timeoutlen=300
  '';
}
