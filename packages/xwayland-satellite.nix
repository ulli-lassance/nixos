{
  lib,
  fetchFromGitHub,
  xwayland-satellite,
  rustPlatform,
}:

xwayland-satellite.overrideAttrs (oldAttrs: rec {
  version = "git-main";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = "main";
    hash = "sha256-wToKwH7IgWdGLMSIWksEDs4eumR6UbbsuPQ42r0oTXQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-jbEihJYcOwFeDiMYlOtaS8GlunvSze80iWahDj1qDrs=";
  };

  buildFeatures = [ "systemd" ];

  buildNoDefaultFeatures = true;
})
