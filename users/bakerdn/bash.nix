{...}: {
  programs.bash.enable = true;
  programs.bash.historyControl = [
    "erasedups"
    "ignoredups"
    "ignorespace"
  ];
  programs.bash.historyFileSize = 100000;
  programs.bash.historySize = 10000;
  programs.bash.initExtra = ''
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/tweag-github
  '';
  programs.bash.shellAliases = {
    lse = "ls -Fho";
    lsa = "lse -A";
  };
  programs.bash.shellOptions = [
    # Append to history file rather than replacing it.
    "histappend"

    # Check the window size after each command and, if necessary, update the
    # values of LINES and COLUMNS.
    "checkwinsize"

    # Extended globbing.
    "extglob"
    "globstar"

    # Warn if closing shell with running jobs.
    "checkjobs"

    # Do not fix cd commands or cd into a directory if a command was given that
    # matches a directory name.
    "-autocd"
    "-cdspell"
  ];
}
