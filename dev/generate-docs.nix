let
  inherit (builtins) mapAttrs getFlake;
  flake = getFlake (toString ../.);
  keysToRemove = [
    "defaultFunc"
    "mergeFunc"
  ];
in
mapAttrs (_: wrapper: {
  options = mapAttrs (
    _: option:
    removeAttrs option keysToRemove
    // {
      type = option.type.name;
    }
  ) wrapper.options;
}) flake.wrapperModules
