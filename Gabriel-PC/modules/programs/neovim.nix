{ config, pkgs, ... }:
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Neovim
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
let
  InitConf = pkgs.writeText "init.lua" ''
    vim.cmd("set expandtab")
    vim.cmd("set tabstop=2")
    vim.cmd("set softtabstop=2")
    vim.cmd("set shiftwidth=2")
    vim.cmd("set number")
    vim.cmd("set relativenumber")


    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "tex", "markdown" },
      callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "es,en_us"
      end,
    })

    vim.api.nvim_set_keymap('n', '<C-e>', ':!xdg-open https://excalidraw.com<CR>', { noremap = true, silent = true })


    vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})

    require("config.lazy")
  '';
  LazyConf = pkgs.writeText "lazy.lua" ''
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com/folke/lazy.nvim.git"
      local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    end
    vim.opt.rtp:prepend(lazypath)

    -- Make sure to setup `mapleader` and `maplocalleader` before
    -- loading lazy.nvim so that mappings are correct.
    -- This is also a good place to setup other settings (vim.opt)
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"

    -- Setup lazy.nvim
    require("lazy").setup({
      spec = {
        -- import your plugins
        { import = "plugins" },
      },
      -- Configure any other settings here. See the documentation for more details.
      -- colorscheme that will be used when installing plugins.
      install = { colorscheme = { "habamax" } },
      -- automatically check for plugin updates
      checker = { enabled = true },
    })
  '';
  PluginColorConf = pkgs.writeText "colorscheme.lua" ''
    return {
      -- the colorscheme should be available when starting Neovim
      {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
          -- load the colorscheme here
          vim.cmd([[colorscheme tokyonight]])
        end,
      },
    }
  '';
  PluginTreeConf = pkgs.writeText "neo-tree.lua" ''
     return{
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
          -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
      } 
  '';
  PluginMdConf = pkgs.writeText "render-markdown.lua" ''
return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
}
  '';
  PluginSnippetsConf = pkgs.writeText "snippets.lua" ''
    return {
      -- Install UltiSnips
      {
        "SirVer/ultisnips",
        config = function()
          -- Your configuration options for UltiSnips here
          vim.g.UltiSnipsExpandTrigger = "<tab>"          -- Define the expand trigger
          vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"     -- Jump forward trigger
          vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"    -- Jump backward trigger
          vim.g.UltiSnipsEditSplit = "vertical"          -- Edit snippets in a vertical split
        end
      },

      -- Install vim-snippets (optional but recommended)
      {
        "honza/vim-snippets",
      },
    } 
  '';
  PluginVimTexConf = pkgs.writeText "vimtex.lua" ''
    return{
      "lervag/vimtex",
      lazy = false,     -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "zathura"
      end
    }
  '';
  PluginWhichConf = pkgs.writeText "which-key.lua" ''
    return {
      {"folke/which-key.nvim", lazy = true },
    } 
  '';
  SnippetsConf = pkgs.writeText "which-key.lua" ''
    snippet \beg "begin{} / end{}" bA
    \begin{$1}
	$0
    \end{$1}
    endsnippet

    snippet \enu "enumeration" bA
    \begin{enumerate}
	\item $1
	\item	$2
    \end{enumerate}
    endsnippet

    snippet \ite "itemization" bA
    \begin{itemize}
	\item $1
	\item	$2
    \end{itemize}
    endsnippet

    snippet \fig "begin{fig} / end{fig}" bA
    \begin{figure}[H]
	\centering
	\includegraphics[width=\textwidth, keepaspectratio]{images/$1}
	\caption{$2}
	\label{fig:$3}
    \end{figure}

    $0
    endsnippet


    snippet \fors "Small formula" bA
    \begin{equation}\label{form:$1}
    	$2
    \end{equation}

    $0
    endsnippet

    snippet \forl "Large formula" bA
    \begin{align}\label{form:$2}
	$0 &= \\\
    \end{align}
    endsnippet


    snippet \code "Code block" bA
    \begin{lstlisting}[
	language=$1,
	caption={$2},
	label={lst:$3},
    	mathescape=true,
	breaklines=true]
    	$4
    \end{lstlisting}

    $0
    endsnippet



    snippet \boxp "Generate an excersize box" bA
    \begin{tcolorbox}[colback=red!5!white,colframe=red!75!black,title=Problem: $1]
    $2
    \tcblower
    $3
    \end{tcolorbox}

    $0
    endsnippet


    snippet \boxe "Generate an Example box" bA
    \begin{tcolorbox}[colback=blue!5!white,colframe=blue!75!black,title=Example: $1]
    $2
    \end{tcolorbox}

    $0
    endsnippet

    snippet \sec "New section" bA
    \section{$1}
    $0
    endsnippet

    snippet \sub "New subsection" bA
    \subsection{$1}
    $0
    endsnippet

    snippet \ssub "New subsubsection" bA
    \subsubsection{$1}
    $0
    endsnippet 
  '';
in
{

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ]; 
  
  environment.systemPackages = with pkgs; [
     neovim
  ];

environment.etc."xdg/nvim/spell/es.utf-8.spl".source =
  pkgs.fetchurl {
    url = "https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.spl";
    sha256 = "sha256-ljY3rJJc+KUb8gf6w5LWtMaXlXEdzC1ICbeIRq42e+M=";
};

environment.etc."xdg/nvim/spell/es.utf-8.sug".source =
  pkgs.fetchurl {
    url = "https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.sug";
    sha256 = "sha256-5w80eKplPCrpBQhjKPv/TkO9ZG12U0ZF9QplNEgBvWw=";
};

  # DotFiles
  systemd.tmpfiles.rules = [
    # Create Folders
    "d /home/${config.globals.username}/.config/nvim 0755 ${config.globals.username} users -"
    "d /home/${config.globals.username}/.config/nvim/lua 0755 ${config.globals.username} users -"
    "d /home/${config.globals.username}/.config/nvim/lua/config 0755 ${config.globals.username} users -"
    "d /home/${config.globals.username}/.config/nvim/lua/plugins 0755 ${config.globals.username} users -"
    "d /home/${config.globals.username}/.config/nvim/UltiSnips 0755 ${config.globals.username} users -"
    "d /home/${config.globals.username}/.config/nvim/spell 0755 ${config.globals.username} users -"

    # Create Files
    "r /home/${config.globals.username}/.config/nvim/init.lua"
    "r /home/${config.globals.username}/.config/nvim/lua/config/lazy.lua"
    "r /home/${config.globals.username}/.config/nvim/lua/plugins/colorscheme.lua"
    "r /home/${config.globals.username}/.config/nvim/lua/plugins/neo-tree.lua"
    "r /home/${config.globals.username}/.config/nvim/lua/plugins/render-markdown.lua"
    "r /home/${config.globals.username}/.config/nvim/lua/plugins/snippets.lua"
    "r /home/${config.globals.username}/.config/nvim/lua/plugins/vimtex.lua"
    "r /home/${config.globals.username}/.config/nvim/lua/plugins/which-key.lua"
    "r /home/${config.globals.username}/.config/nvim/UltiSnips/tex.snippets"

    # Link Files
    "L+ /home/${config.globals.username}/.config/nvim/init.lua - - - - ${InitConf}"
    "L+ /home/${config.globals.username}/.config/nvim/lua/config/lazy.lua - - - - ${LazyConf}"
    "L+ /home/${config.globals.username}/.config/nvim/lua/plugins/colorscheme.lua - - - - ${PluginColorConf}"
    "L+ /home/${config.globals.username}/.config/nvim/lua/plugins/neo-tree.lua - - - - ${PluginTreeConf}"
    "L+ /home/${config.globals.username}/.config/nvim/lua/plugins/render-markdown.lua - - - - ${PluginMdConf}"
    "L+ /home/${config.globals.username}/.config/nvim/lua/plugins/snippets.lua - - - - ${PluginSnippetsConf}"
    "L+ /home/${config.globals.username}/.config/nvim/lua/plugins/vimtex.lua - - - - ${PluginVimTexConf}"
    "L+ /home/${config.globals.username}/.config/nvim/lua/plugins/which-key.lua - - - - ${PluginWhichConf}"
    "L+ /home/${config.globals.username}/.config/nvim/UltiSnips/tex.snippets - - - - ${SnippetsConf}"
    "L+ /home/${config.globals.username}/.config/nvim/spell/es.utf-8.spl - - - - /etc/xdg/nvim/spell/es.utf-8.spl"
    "L+ /home/${config.globals.username}/.config/nvim/spell/es.utf-8.sug - - - - /etc/xdg/nvim/spell/es.utf-8.sug"
  ];
}
