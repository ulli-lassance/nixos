{ ... }:

{
  home.file = {
    "Pictures/wallpapers" = {
      source = ./../../../../assets/wallpapers;
      recursive = true;
    };

    "Pictures/.remilia.jpg" = {
      source = ./../../../../assets/.remilia.jpg;
    };
  };
}
