{
  lib,
  pkgs,
  ...
}:
with lib;
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "hickory-dns";
    version = "0.26.0-alpha.1";

    src = fetchFromGitHub {
      owner = "hickory-dns";
      repo = "hickory-dns";
      tag = "v${finalAttrs.version}";
      hash = "sha256-/cgyGKEkTQgn3bsC75HZ1JuFbWLn2dSHpfS4/eyMAVI=";
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-q54faGF/eLdCRB0Eljkgl/x78Fnpm0eAEK9gCUwiAgo=";

    buildInputs = [openssl];
    nativeBuildInputs = [pkg-config];

    # tests expect internet connectivity to query real nameservers like 8.8.8.8
    doCheck = false;

    passthru.updateScript = nix-update-script {};

    meta = {
      description = "Rust based DNS client, server, and resolver";
      homepage = "https://hickory-dns.org/";
      maintainers = with lib.maintainers; [colinsane];
      platforms = lib.platforms.linux;
      license = with lib.licenses; [
        asl20
        mit
      ];
      mainProgram = "hickory-dns";
    };
  })
