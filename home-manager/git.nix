{ ... }:
{
  programs.git = {
    enable = true;
    signing = {
      key = "A12A7532A32DF8DCFD391AC87E9400C4F7763DE6";
      signByDefault = true;
    };
    settings = {
      user = {
        email = "alex@rezvov.ru";
        name = "Alexander Rezvov";
      };
      init.defaultBranch = "master";
    };
  };
}
