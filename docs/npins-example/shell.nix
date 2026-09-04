{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs {},
  wrappers ? import ./wrappers.nix { inherit sources pkgs; }
}:

pkgs.mkShellNoCC {
  packages = [
    wrappers.foo
    wrappers.bar
    wrappers.baz
  ];
}
