let
  inherit (builtins) attrNames filter mapAttrs getFlake;
  filterAttrValues = pred: set: removeAttrs set (filter (name: !pred set.${name}) (attrNames set));
  keysToRemove = [
    "defaultFunc"
    "mergeFunc"
  ];
  flake = getFlake (toString ../.);

  # modules can opt out of docs generation by setting `meta.renderDocs = false;`
  filteredModules = filterAttrValues (
    wrapper: (wrapper.meta.renderDocs or null) != false
  ) flake.wrapperModules;
in
mapAttrs (_: wrapper: {
  options = mapAttrs (
    _: option:
    removeAttrs option keysToRemove
    // {
      type = option.type.name;
    }
  ) wrapper.options;
}) filteredModules
