{
  description = "Wrapper for creating a NixOS system configuration.";

  nixConfig = {
    extra-substituters = [
      "https://mrcjkb.cachix.org"
      "https://arm.cachix.org"
      "https://nix-community.cachix.org"
      "https://nomad.cachix.org"
    ];
    extra-trusted-public-keys = [
      "mrcjkb.cachix.org-1:KhpstvH5GfsuEFOSyGjSTjng8oDecEds7rbrI96tjA4="
      "arm.cachix.org-1:5BZ2kjoL1q6nWhlnrbAl+G7ThY7+HaBRD9PZzqZkbnM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs"
      "nomad.cachix.org-1:jQ4al6yxQyvUBB7YJVJbMbc9rASokqamqvPhBUrVjww="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    feedback = {
      url = "github:NorfairKing/feedback";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    atuin = {
      url = "github:atuinsh/atuin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-sessionizer = {
      url = "github:jrmoulton/tmux-sessionizer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    serena = {
      url = "github:oraios/serena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nu-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    bash-env-nushell = {
      url = "github:tesujimath/bash-env-nushell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jj = {
      url = "github:jj-vcs/jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:mrcjkb/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Neovim
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neorocks = {
      url = "github:nvim-neorocks/neorocks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gen-luarc = {
      url = "github:mrcjkb/nix-gen-luarc-json";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spell-de-dictionary = {
      url = "https://www.mirrorservice.org/pub/vim/runtime/spell/de.utf-8.spl";
      flake = false;
    };
    spell-de-suggestions = {
      url = "https://www.mirrorservice.org/pub/vim/runtime/spell/de.utf-8.sug";
      flake = false;
    };

    # Neovim plugins
    haskell-tools = {
      url = "github:mrcjkb/haskell-tools.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neotest-haskell = {
      url = "github:mrcjkb/neotest-haskell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lz-n = {
      url = "github:nvim-neorocks/lz.n";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crates-nvim = {
      url = "github:saecki/crates.nvim";
      flake = false;
    };
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    sqlite = {
      url = "github:kkharji/sqlite.lua";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    vim-wordmotion = {
      # Vimscript
      url = "github:chaoren/vim-wordmotion";
      flake = false;
    };
    nvim-highlight-colors = {
      url = "github:brenoprata10/nvim-highlight-colors";
      flake = false;
    };
    flash-nvim = {
      url = "github:folke/flash.nvim";
      flake = false;
    };
    eyeliner-nvim = {
      url = "github:jinh0/eyeliner.nvim";
      flake = false;
    };
    gitlinker = {
      url = "github:linrongbin16/gitlinker.nvim";
      flake = false;
    };
    surround = {
      url = "github:kylechui/nvim-surround";
      flake = false;
    };
    substitute = {
      url = "github:gbprod/substitute.nvim";
      flake = false;
    };
    persistence = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };
    nvim-lastplace = {
      url = "github:mrcjkb/nvim-lastplace";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neotest = {
      url = "github:nvim-neotest/neotest";
      flake = false;
    };
    nio = {
      url = "github:nvim-neotest/nvim-nio";
      flake = false;
    };
    neotest-busted = {
      url = "gitlab:HiPhish/neotest-busted";
      flake = false;
    };
    schemastore-nvim = {
      url = "github:b0o/SchemaStore.nvim";
      flake = false;
    };
    jdtls = {
      # FIXME: Update setup in dotfiles
      url = "github:mfussenegger/nvim-jdtls";
      flake = false;
    };
    live-rename-nvim = {
      url = "github:saecki/live-rename.nvim";
      flake = false;
    };
    fidget = {
      url = "git+https://github.com/j-hui/fidget.nvim.git";
      flake = false;
    };
    illuminate = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    actions-preview-nvim = {
      url = "github:aznhe21/actions-preview.nvim";
      flake = false;
    };
    treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects/main";
      flake = false;
    };
    vim-matchup = {
      # tree-sitter powered % motions
      url = "github:andymass/vim-matchup";
      flake = false;
    };
    telescope = {
      url = "github:nvim-telescope/telescope.nvim/feat/neoplen";
      flake = false;
    };
    telescope_hoogle = {
      url = "github:luc-tielen/telescope_hoogle";
      flake = false;
    };
    telescope-smart-history = {
      url = "github:nvim-telescope/telescope-smart-history.nvim";
      flake = false;
    };
    telescope-zf-native = {
      url = "github:natecraddock/telescope-zf-native.nvim";
      flake = false;
    };
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };
    oil-nvim = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
    harpoon = {
      url = "github:ThePrimeagen/harpoon/harpoon2";
      flake = false;
    };
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    nvim-bqf = {
      url = "github:kevinhwang91/nvim-bqf";
      flake = false;
    };
    quicker-nvim = {
      url = "github:stevearc/quicker.nvim";
      flake = false;
    };
    yanky = {
      url = "github:gbprod/yanky.nvim";
      flake = false;
    };
    nvim-unception = {
      # Prevent nested neovim instances
      url = "github:samjwill/nvim-unception";
      flake = false;
    };
    term-edit-nvim = {
      url = "github:chomosuke/term-edit.nvim";
      flake = false;
    };
    other-nvim = {
      url = "github:rgroli/other.nvim";
      flake = false;
    };
    which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
  };

  outputs = inputs: let
    findModulesList = import ./lib/find-modules-list.nix {inherit (inputs.nixpkgs) lib;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = builtins.attrNames inputs.nixpkgs.legacyPackages;
      imports = builtins.concatMap findModulesList [./modules ./profiles ./hosts];
    };
}
