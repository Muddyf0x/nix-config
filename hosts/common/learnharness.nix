{
  appimageTools,
  fetchurl,
  lib,
  # { ENV_VAR = "/path/to/file"; } read at launch, e.g. sops secret paths.
  # LearnHarness prefers real env vars over keys saved in its auth.json.
  keyFiles ? { },
}:

let
  pname = "learnharness";
  version = "0.4.1";
  # The in-app updater is inactive under appimageTools, so new releases mean
  # bumping version + hash here (GitHub lists each asset's sha256 digest).
  src = fetchurl {
    url = "https://github.com/amosblomqvist/learnharness/releases/download/v${version}/LearnHarness-${version}-x86_64.AppImage";
    hash = "sha256-n8aA23BE2DD7yePDAbuWcLc29jo22bYivln2toh3DNg=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Sourced inside the sandbox right before the app starts. The app also hands
  # these to the Claude Code CLI provider, so an ANTHROPIC_API_KEY here moves
  # that provider from subscription to API billing.
  profile = lib.concatLines (
    lib.mapAttrsToList (var: file: ''
      if [ -r ${lib.escapeShellArg file} ]; then export ${var}="$(cat ${lib.escapeShellArg file})"; fi
    '') keyFiles
  );

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm444 ${contents}/learnharness.desktop $out/share/applications/learnharness.desktop
      substituteInPlace $out/share/applications/learnharness.desktop \
        --replace-fail "Exec=AppRun --no-sandbox %U" "Exec=learnharness %U"

      install -Dm444 ${contents}/usr/share/icons/hicolor/512x512/apps/learnharness.png $out/share/icons/hicolor/512x512/apps/learnharness.png
    '';

  meta = {
    description = "Desktop app for AI-guided teaching and practice with a persistent knowledge graph";
    homepage = "https://learnharness.ai";
    license = lib.licenses.agpl3Only;
    mainProgram = "learnharness";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
