{
  pkgs ? import <nixpkgs> {},
  lib,
  # dbus,
  # eudev,
  # fetchFromGitHub,
  # installShellFiles,
  # libdisplay-info,
  # libglvnd,
  # libinput,
  # libxkbcommon,
  # libgbm,
  # versionCheckHook,
  # nix-update-script,
  # pango,
  # pipewire,
  # pkg-config,
  # rustPlatform,
  # seatd,
  # stdenv,
  # systemd,
  # wayland,
  # withDbus ? true,
  # withDinit ? false,
  # withScreencastSupport ? true,
  # withSystemd ? true,
  ...
}: let
  withDbus = true;
  withDinit = false;
  withScreencastSupport = true;
  withSystemd = true;
in
  with lib;
  with pkgs;
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "niri";
      version = "25.05.1";

      # src = fetchFromGitHub {
      #   owner = "titaniumtraveler";
      #   repo = "niri";
      #   rev = "fork/main";
      #   # tag = "v${finalAttrs.version}";
      #   hash = "sha256-8gjv27fsTLr+eGgKKXDkVqRgFY5LDR02aWAFN8COcJM=";
      #   # hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      # };
      # cargoHash = "sha256-HlTHlUnXxpllY0xH7fa/F67o7haDoSXJpZn3opwxTCA=";

      # src = fetchFromGitHub {
      #   owner = "YaLTeR";
      #   repo = "niri";
      #   rev = "wip/mergeable-layout";
      #   hash = "sha256-OjQGbps91MZtvC8KmnN/9gue5C21URvEXNY+lLGUA+k=";
      # };
      # cargoHash = "sha256-Uvf11daCy5m3muun9BXmOw9uiy8L53FgUwyUSxCHaIk=";

      src = fetchFromGitHub {
        owner = "YaLTeR";
        repo = "niri";
        rev = "wip/include";
        hash = "sha256-/4F/27P8ZUVAVhFsUXsWlC1l2Jvo6Oux6LSuS4pAAhk=";
      };
      cargoHash = "sha256-Uvf11daCy5m3muun9BXmOw9uiy8L53FgUwyUSxCHaIk=";

      postPatch = ''
        patchShebangs resources/niri-session
        substituteInPlace resources/niri.service \
          --replace-fail '/usr/bin' "$out/bin"
      '';

      useFetchCargoVendor = true;
      # cargoHash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";

      strictDeps = true;

      nativeBuildInputs = [
        installShellFiles
        pkg-config
        rustPlatform.bindgenHook
      ];

      buildInputs =
        [
          libdisplay-info
          libglvnd # For libEGL
          libinput
          libxkbcommon
          libgbm
          pango
          seatd
          wayland # For libwayland-client
        ]
        ++ lib.optional (withDbus || withScreencastSupport || withSystemd) dbus
        ++ lib.optional withScreencastSupport pipewire
        ++ lib.optional withSystemd systemd # Includes libudev
        ++ lib.optional (!withSystemd) eudev; # Use an alternative libudev implementation when building w/o systemd

      buildFeatures =
        lib.optional withDbus "dbus"
        ++ lib.optional withDinit "dinit"
        ++ lib.optional withScreencastSupport "xdp-gnome-screencast"
        ++ lib.optional withSystemd "systemd";
      buildNoDefaultFeatures = true;

      postInstall =
        ''
          install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
        ''
        + lib.optionalString withDbus ''
          install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
        ''
        + lib.optionalString (withSystemd || withDinit) ''
          install -Dm0755 resources/niri-session -t $out/bin
        ''
        + lib.optionalString withSystemd ''
          install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/lib/systemd/user
        ''
        + lib.optionalString withDinit ''
          install -Dm0644 resources/dinit/niri{-shutdown,} -t $out/lib/dinit.d/user
        ''
        + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
          installShellCompletion --cmd $pname \
            --bash <($out/bin/niri completions bash) \
            --fish <($out/bin/niri completions fish) \
            --zsh <($out/bin/niri completions zsh)
        '';

      env = {
        # Force linking with libEGL and libwayland-client
        # so they can be discovered by `dlopen()`
        RUSTFLAGS = toString (
          map (arg: "-C link-arg=" + arg) [
            "-Wl,--push-state,--no-as-needed"
            "-lEGL"
            "-lwayland-client"
            "-Wl,--pop-state"
          ]
        );
      };

      nativeInstallCheckInputs = [versionCheckHook];
      versionCheckProgramArg = "--version";
      doInstallCheck = false;
      doCheck = false;

      passthru = {
        providedSessions = ["niri"];
        updateScript = nix-update-script {};
      };

      meta = {
        description = "Scrollable-tiling Wayland compositor";
        homepage = "https://github.com/YaLTeR/niri";
        changelog = "https://github.com/YaLTeR/niri/releases/tag/v${finalAttrs.version}";
        license = lib.licenses.gpl3Only;
        maintainers = with lib.maintainers; [
          iogamaster
          foo-dogsquared
          sodiboo
          getchoo
        ];
        mainProgram = "niri";
        platforms = lib.platforms.linux;
      };
    })
