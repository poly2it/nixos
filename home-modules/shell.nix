{ ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    PS1 = "\\[\\033[1;95m\\033[1m\\]\\w\\[\\033[0m\\]\\$ ";
    NIX_SHELL_PRESERVE_PROMPT = "1";
  };

  home.shellAliases = {
    nd = "nix develop";
    nf = "nix fmt";
    nc = "nix flake check";
    ex = "exit";
    la = "ls -A";
    ll = "la -l -h";
    cat = "bat";
    icat = "kitty +kitten icat --";
    top = "htop";
    colmena = "NIXPKGS_ALLOW_UNFREE=1 colmena --experimental-flake-eval --impure";
    v = "nvim";
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      unset __HM_SESS_VARS_SOURCED
      . "/etc/profiles/per-user/$(whoami)/etc/profile.d/hm-session-vars.sh"
    '';
  };
}

