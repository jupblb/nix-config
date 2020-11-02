{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; [
    gitAndTools.git-crypt htop ranger screen unzip
  ];
  home.sessionVariables = { EDITOR = "nvim"; };
  home.username         = "jupblb";

  nixpkgs.config.packageOverrides = pkgs: {
    gitAndTools = pkgs.gitAndTools // {
      delta = pkgs.callPackage ./misc/delta.nix {
        inherit (pkgs.darwin.apple_sdk.frameworks) Security;
      };
    };
    ranger      = pkgs.callPackage ./misc/ranger { ranger = pkgs.ranger; };
  };

  programs = {
    fish = {
      enable       = true;
      plugins      = [ {
        name = "bobthefish";
        src  = pkgs.fetchFromGitHub {
          owner  = "oh-my-fish";
          repo   = "theme-bobthefish";
          rev    = "a2ad38aa051aaed25ae3bd6129986e7f27d42d7b";
          sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
        };
      } {
        name = "nix-env";
        src  = pkgs.fetchFromGitHub {
          owner  = "lilyball";
          repo   = "nix-env.fish";
          rev    = "master";
          sha256 = "0hvj3zqrx5vhbhcszrgd9cczkn97236zfbx7iwjx3grnk556r53c";
        };
      } ];
      promptInit   = builtins.readFile ./misc/prompt.fish;
      shellAliases = {
        nix-shell = "nix-shell --command fish";
        ssh       = "env TERM=xterm-256color ssh";
        vim       = "nvim";
      } // (let bat = "${pkgs.bat}/bin/bat --theme=gruvbox-light"; in {
        cat  = "${bat} -p --paging=never";
        less = "${bat} -p --paging=always";
      });
    };

    fzf = {
      enable         = true;
      defaultOptions = [ "--color=light" ];
    };

    git = {
      delta       = {
        enable  = true;
        options = {
          line-numbers            = true;
          line-numbers-zero-style = "#3c3836";
          minus-emph-style        = "syntax #fa9f86";
          minus-style             = "syntax #f9d8bc";
          plus-emph-style         = "syntax #d9d87f";
          plus-style              = "syntax #eeebba";
          side-by-side            = true;
          syntax-theme            = "gruvbox-light";
        };
      };
      enable      = true;
      extraConfig = {
        color.ui          = true;
        core.mergeoptions = "--no-edit";
        fetch.prune       = true;
        pull.rebase       = true;
        push.default      = "upstream";
      };
      signing     = { key = "1F516D495D5D8D5B"; signByDefault = true; };
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    gpg.enable = true;

    kitty = {
      enable      = true;
      extraConfig = builtins.readFile(pkgs.fetchFromGitHub {
        owner  = "wdomitrz";
        repo   = "kitty-gruvbox-theme";
        rev    = "master";
        sha256 = "0s1jbmw3xzzg00lxkxk4ryhhyxck5an7nmrq5cy9vdp1f1a0lgrr";
      } + "/gruvbox_light.conf");
      settings    = {
        font_family         = "PragmataPro Mono Liga";
        font_size           = 10;
        startup_session     = builtins.toString(pkgs.writeTextFile {
          name = "kitty-launch";
          text = "launch fish -C '${pkgs.fortune}/bin/fortune -sa'";
        });
      };
    };

    neovim = {
      extraConfig   = builtins.readFile ./misc/nvim/init.vim;
      plugins       = with pkgs.vimPlugins; [ {
          plugin = lightline-vim;
          config = ''
            set noshowmode
            let g:lightline = { 'colorscheme': 'gruvbox' }
          '';
        } {
          plugin = calendar-vim;
          config = ''
            let google_calendar = "${./misc/nvim/google-calendar.vim}"
            ${builtins.readFile ./misc/nvim/calendar-vim.vim}
          '';
        } {
          plugin = goyo;
          config = "let g:goyo_width = 100 | nmap <silent><Leader>` :Goyo<CR>";
        } {
          plugin = gruvbox-community;
          config = builtins.readFile ./misc/nvim/gruvbox-community.vim;
        } {
          plugin = fzf-vim;
          config = builtins.readFile ./misc/nvim/fzf-vim.vim;
        } {
          plugin = nvim-lspconfig;
          config = builtins.readFile ./misc/nvim/nvim-lspconfig.vim;
        } {
          plugin = ranger-vim;
          config = "nnoremap <Leader><CR> :RangerEdit<CR>";
        } {
          plugin = vimwiki;
          config = ''
            let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
                \ 'syntax': 'markdown', 'ext': '.md'}]
          '';
        }
        editorconfig-vim vim-polyglot vim-signify
      ];
      enable        = true;
      extraPackages = with pkgs; [
        nodePackages.bash-language-server ripgrep rnix-lsp
      ];
      package       = pkgs.neovim-unwrapped.overrideAttrs(old: {
        version = "nightly";
        src     = builtins.fetchGit {
          url = https://github.com/neovim/neovim.git;
          ref = "nightly";
        };
      });
      vimAlias      = true;
      vimdiffAlias  = true;
      withPython    = false;
      withPython3   = false;
      withRuby      = false;
    };

    ssh = {
      compression         = true;
      controlMaster       = "auto";
      controlPersist      = "yes";
      enable              = true;
      forwardAgent        = true;
      matchBlocks         =
        let key = {
          identitiesOnly = true;
          identityFile   = [ (builtins.toString ./misc/ssh/id_ed25519) ];
        };
        in {
          "github.com" = key;
          hades        = key // { hostname = "jupblb.ddns.net"; port = 1993; };
          iris         = key // { hostname = "jupblb.ddns.net"; port = 1994; };
        };
      serverAliveInterval = 30;
    };
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text =
    lib.mkAfter "for f in $plugin_dir/*.fish; source $f; end";
}

