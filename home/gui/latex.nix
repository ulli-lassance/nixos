{ pkgs, ... }:

let
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-basic
      collection-langportuguese
      collection-langenglish
      amsmath
      makecell
      multirow
      booktabs
      siunitx
      float
      gensymb
      latexmk
      ;
  };
in
{
  home.packages = with pkgs; [
    texstudio
    tex
  ];
}
