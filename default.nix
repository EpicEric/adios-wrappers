{ adios } @ args:

let
  warn = builtins.warn or builtins.trace;
  adios =
    if builtins.isPath args.adios || args.adios ? outPath then
      warn ''
        The adios-wrappers 'default.nix' now expects to be passed an instantiated `adios` function, rather than the source.

        Where one would previously do:
        ```
          adios = import sources.adios;
          adios-wrappers = import sources.adios-wrappers { adios = sources.adios; }
        ```
        Instead, do:
        ```
          adios = import sources.adios;
          adios-wrappers = import sources.adios-wrappers { inherit adios; }
        ```'' (import args.adios)
    else
      args.adios;
in
adios.lib.importModules {
  directory = ./modules;
  args = adios // {
    assertions.disjoint = a: b: {
      verify = { options }: !(options ? ${a} && options ? ${b});
      explain = { options }: "'options.${a}' and 'options.${b}' are disjoint, but both were set";
    };
  };
}
