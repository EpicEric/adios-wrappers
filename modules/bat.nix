{ types, promise, assertions, ... }:
{
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    flags = {
      type = types.listOf types.string;
      description = ''
        Flags to be appended by default when running bat.

        Disjoint with the `configFile` option.
      '';
    };
    configFile = {
      type = types.pathLike;
      description = ''
        File containing the flags to be appended by default when running bat.

        Disjoint with the `flags` option.
      '';
    };

    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.bat);
      description = "The bat package to be wrapped.";
    };
  };

  assertions = [
    (assertions.disjoint "flags" "configFile")
  ];

  inputs.mkWrapper.options = promise (
    { options, inputs }:
    if options ? flags then
      {
        inherit (options) package flags;
      }
    else
      {
        inherit (options) package;
        environment = {
          BAT_CONFIG_PATH = options.configFile;
        };
      }
  );

  result = promise (
    { results, options }:
    # TODO: use an assertion that guarantees one of the options is set
    if options ? flags || options ? configFile then results.mkWrapper else options.package
  );

  meta = {
    maintainers = [ "llakala" ];
  };
}
