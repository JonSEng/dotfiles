{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2; # fast key repeat
      InitialKeyRepeat = 15; # short delay before repeat
      _HIHideMenuBar = true; # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv"; # list view by default
    finder.CreateDesktop = false; # clean desktop
    trackpad.Clicking = true; # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "bazelisk"
      "colima"
      "docker"
      "glab"
      "helm"
      "herdr"
      "kind"
      "kubernetes-cli"
      "lima"
      "mas"
      "skaffold"
    ];
    casks = [
      "1password"
      "ai-pim-utils"
      "anytype"
      "beeper"
      "brave-browser"
      "capacities"
      "cardhop"
      "chatgpt"
      "chrome-remote-desktop-host"
      "claude"
      "claude-code"
      "cursor"
      "daisydisk"
      "dcv-viewer"
      "discord"
      "dropbox"
      "fantastical"
      "ferdium"
      "fission"
      "iina"
      "lastpass"
      "linear"
      "logi-options+"
      "logos"
      "loopback"
      "microsoft-outlook"
      "notion"
      "obsidian"
      "piezo"
      "raycast"
      "reader"
      "sbx"
      "setapp"
      "slack"
      "soundsource"
      "spotify"
      "sunsama"
      "thebrowsercompany-dia"
      "updf"
      "warp"
      "wechat"
      "wezterm"
      "wispr-flow"
    ];
  };
}
