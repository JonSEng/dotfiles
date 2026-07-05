README Make it yours references checked against committed files

$ sed -n '18p;26p' flake.nix
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
          home-manager.users.kunchen = import ./home.nix;

$ sed -n '8p;10,12p;30p;34p;37,39p' configuration.nix
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU
  system.primaryUser = "kunchen";
  users.users.kunchen = {
    home = "/Users/kunchen";
    user = "kunchen";
    onActivation.cleanup = "zap";  # remove anything not listed here
    brews = [
      "herdr"
    ];

$ sed -n '8,9p;38,45p;71,76p' home.nix
  home.username = "kunchen";
  home.homeDirectory = "/Users/kunchen";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.git.settings.user = {
    name = "kunchenguid";
    email = "kun@kunchenguid.com";
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

$ sed -n '5p' rebuild.sh
exec sudo darwin-rebuild switch --flake ~/.dotfiles#mac

Assertions:
All README personalization and safety references resolve to the expected committed lines.
