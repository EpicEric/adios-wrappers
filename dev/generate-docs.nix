let
  inherit (builtins) attrNames filter mapAttrs getFlake;
  flake = getFlake (toString ../.);
  keysToRemove = [
    "defaultFunc"
    "mergeFunc"
  ];

  filterAttrValues = pred: set: removeAttrs set (filter (name: !pred set.${name}) (attrNames set));
in
mapAttrs (_: wrapper: {
  options = mapAttrs (
    _: option:
    removeAttrs option keysToRemove
    // {
      type = option.type.name;
    }
  ) wrapper.options;
}) (filterAttrValues (wrapper: (wrapper.meta.renderDocs or null) != false) flake.wrapperModules)
