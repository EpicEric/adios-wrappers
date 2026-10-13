{ types, promise, ... }:
{
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
    git.from = { parent }: parent.git;
  };

  options = {
    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.diff-so-fancy);
      description = "The diff-so-fancy package to be wrapped.";
    };
  };

  inputs.mkWrapper.options = promise (
    { options, inputs, results }:
    {
      inherit (options) package;
      environment = {
        # If you don't have this, diff-so-fancy can't find your gitconfig
        GIT_CONFIG_GLOBAL = "${results.git}/git/config";
      };
    }
  );

  result = promise ({ results }: results.mkWrapper);

  meta = {
    maintainers = [ "llakala" ];
  };
}
