{ pkgs, lib, ... }:

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
    # colmena = "NIXPKGS_ALLOW_UNFREE=1 colmena --experimental-flake-eval --impure";
    gc = "git commit";
    gcm = "git commit -m";
    gs = "git status";
    ga = "git add";
    gu = "git unadd";
    gd = "git diff --staged";
    gp = "git pull";
    gf = "git fetch";
    ssh = "kitty +kitten ssh";
    v = "nvim";
  };

  programs.bash = {
    enable = true;
    initExtra = lib.mkOrder 0 ''
      nr() { local PKG="$1"; shift; nix run "nixpkgs#$PKG" -- $@; }
      unset __HM_SESS_VARS_SOURCED
      . "/etc/profiles/per-user/$(whoami)/etc/profile.d/hm-session-vars.sh"

      if command -v direnv >/dev/null 2>&1; then
        if [ -n "$CLAUDECODE" ]; then
          eval "$(direnv hook bash)"
          eval "$(DIRENV_LOG_FORMAT= direnv export bash)"
        fi
      fi
    '';
  };
}
