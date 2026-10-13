{ types, promise, ... }:
{
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    flags = {
      type = types.listOf types.string;
      description = ''
        Flags to be automatically appended when creating the zoxide shell integration.

        See the [documentation](https://github.com/ajeetdsouza/zoxide#flags) of valid flags.
      '';
      default = [];
    };

    excludedDirs = {
      type = types.string;
      description = ''
        Directory globs that won't be added to the database when navigating with zoxide.
      '';
    };

    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.zoxide);
      description = "The zoxide package to be wrapped.";
    };
  };

  mutations = {
    "/fish".interactiveShellInit = promise (
      { options, inputs, result }:
      let
        inherit (inputs.nixpkgs.lib) getExe;
        inherit (builtins) concatStringsSep;
      in
      # fish
      ''
        ${getExe result} init fish ${concatStringsSep " " options.flags} | source
      ''
    );
  };

  inputs.mkWrapper.options = promise (
    { options, inputs }:
    {
      inherit (options) package;
      environment = {
        _ZO_EXCLUDE_DIRS = options.excludedDirs or null;
      };
    }
  );

  result = promise ({ results }: results.mkWrapper);

  meta = {
    maintainers = [ "llakala" ];
  };
}
