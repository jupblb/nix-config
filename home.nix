{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; [ ranger screen unzip ];
  home.sessionVariables = {
    MANPAGER             = "vim -c 'set ft=man' -";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  home.username         = "jupblb";

  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    glow   = writeScriptBin "glow" "${glow}/bin/glow -s light $@";
    ranger = callPackage ./misc/ranger { ranger = pkgs.ranger; };
  };

  programs = {
    # Remember to run `bat cache --build` before first run
    bat.enable         = true;
    bat.themes.gruvbox = builtins.readFile ./misc/gruvbox.tmTheme;

    fish = {
      enable               = true;
      interactiveShellInit = builtins.readFile ./misc/config.fish;
      plugins              = [ {
        name = "bass";
        src  = pkgs.fetchFromGitHub {
          owner  = "edc";
          repo   = "bass";
          rev    = "master";
          sha256 = "0ppmajynpb9l58xbrcnbp41b66g7p0c9l2nlsvyjwk6d16g4p4gy";
        };
      } {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner  = "oh-my-fish";
          repo   = "theme-bobthefish";
          rev    = "a2ad38aa051aaed25ae3bd6129986e7f27d42d7b";
          sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
        };
      } ];
    };

    fzf.enable = true;

    git = {
      delta       = {
        enable  = true;
        options = {
          minus-emph-style = "syntax #fa9f86";
          minus-style      = "syntax #f9d8bc";
          plus-emph-style  = "syntax #d9d87f";
          plus-style       = "syntax #eeebba";
          syntax-theme     = "gruvbox";
        };
      };
      enable      = true;
      extraConfig = {
        color.ui          = true;
        core.mergeoptions = "--no-edit";
        fetch.prune       = true;
        push.default      = "upstream";
      };
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    htop.enable  = true;
    htop.vimMode = true;

    kitty.enable      = true;
    kitty.extraConfig = builtins.readFile(pkgs.fetchurl {
      url    = "https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_light.conf";
      sha256 = "1yvg98vll5yp7nadq2k2q6ri9c9jgk5a5syszbxs7bqpgb27nzha";
    });
    kitty.settings    = {
      font_family     = "PragmataPro Mono Liga";
      font_size       = if pkgs.stdenv.isLinux then 10 else 14;
      startup_session = builtins.toString(pkgs.writeTextFile {
        name = "kitty-launch";
        text = "launch fish -C '${pkgs.fortune}/bin/fortune -sa'";
      });
    };

    neovim = {
      extraConfig   = builtins.readFile ./misc/init.vim;
      plugins       =
        let glow-nvim = pkgs.vimUtils.buildVimPlugin {
          pname   = "glow-nvim";
          version = "2020-10-12";
          src     = pkgs.fetchFromGitHub {
            owner  = "npxbr";
            repo   = "glow.nvim";
            rev    = "master";
            sha256 = "0qkvxly52qdxw77mlrwzrjp8i6smzmsd6k4pd7qqq2w8s8y8rda3";
          };
        };
        in with pkgs.vimPlugins; [ {
            plugin = airline;
            config = ''
              set noshowmode
              let g:airline_powerline_fonts = 1
              let g:airline_theme = 'gruvbox'
            '';
          } {
            plugin = completion-nvim;
            config = ''
              packadd completion-nvim
              set completeopt=menuone,noinsert,noselect
              set shortmess+=c
              imap <silent> <C-Space> <Plug>(completion_trigger)
              inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
              inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
              autocmd BufEnter * lua require'completion'.on_attach()
            '';
          } {
            plugin = glow-nvim;
            config = "nmap <Leader>m :Glow<CR>";
          } {
            plugin = goyo;
            config = "nmap <silent><Leader>` :Goyo<CR>";
          } {
            plugin = gruvbox-community;
            config = ''
              let g:gruvbox_contrast_light = 'hard'
              let g:gruvbox_italic = 1
              colorscheme gruvbox
              autocmd VimEnter * highlight clear Normal
            '';
          } {
            plugin = fzf-vim;
            config = ''
              autocmd! FileType fzf set laststatus=0 noshowmode noruler
                  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
              nnoremap <Leader><Tab> :Buffers<CR>
              nnoremap <Leader>f     :Files<CR>
              nnoremap <Leader>h     :History<CR>
              nnoremap <Leader>g     :Rg<CR>
            '';
          } {
            plugin = nvim-lspconfig;
            config = ''
              packadd nvim-lspconfig
              lua require'nvim_lsp'.bashls.setup{}
              lua require'nvim_lsp'.rnix.setup{}
              nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
              nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
              nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
              nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
              nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
              nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
              nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
              nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
              nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
              nnoremap <silent> <Leader>r <cmd>lua vim.lsp.buf.rename()<CR>
              nnoremap <silent> <Leader>l <cmd>lua vim.lsp.buf.formatting()<CR>
            '';
          } {
            plugin = ranger-vim;
            config = "nnoremap <Leader><CR> :RangerEdit<CR>";
          } {
            plugin = vim-markdown;
            config = "let g:vim_markdown_folding_disabled = 1";
          }
          editorconfig-vim vim-better-whitespace vim-jsonnet vim-nix vim-signify
        ];
      enable        = true;
      extraPackages = with pkgs; [
        glow nodePackages.bash-language-server ripgrep rnix-lsp
      ];
      package       = pkgs.neovim-unwrapped.overrideAttrs(old: {
        version = "nightly";
        src     = pkgs.fetchFromGitHub {
          owner  = "neovim";
          repo   = "neovim";
          rev    = "nightly";
          sha256 = "0z56xv5bmjq8ivkrpvfgbhnq8vxvbr7231ldg7bipf273widw55m";
        };
      });
      vimAlias      = true;
      vimdiffAlias  = true;
      withNodeJs    = false;
      withPython    = false;
      withPython3   = false;
      withRuby      = false;
    };
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish; source $f; end
  '';
}

