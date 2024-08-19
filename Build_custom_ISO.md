# Create custom nixos minimal ISO:

***To build the image:***

```nix run nixpkgs#nixos-generators -- --format iso --flake github:Enkre7/nixos-config#customIso -o result```

_```--format``` can specify other image formats_
