# Nix Cheat Sheet

## Useful Commands

### System rebuild:
`sudo nixos-rebuild switch --flake ~/.dotfiles#<hostname>`

### User rebuild:
`home-manager switch --flake ~/.dotfiles#<username>`

### Update flake.lock:
`nix flake update [input?]`

### Garbage collection:
`sudo nix-collect-garbage --delete-older-than <age>`

### Check why Home Manager failed to start
`sudo journalctl -xe --unit home-manager-<username>`

## Nix Types

https://nixos.org/manual/nixos/stable/#sec-option-types

## Nix Lib/Builtin Functions

[Source of lib](https://github.com/NixOS/nixpkgs/blob/9dfcba812aa0f4dc374acfe0600d591885f4e274/lib/modules.nix)

### map

Apply a function to each element in a list, creating a new list with the outputs.

#### Documentation Link
https://noogle.dev/f/builtins/map

#### Signature
map :: (a -> b) -> [a] -> [b]

#### Example
```
map (x: x * 2) [1 2 3]
=> [2 4 6]
```

### mapAttrs

Apply a function to each name and value in an attribute set, creating a new attribute set with the same names but different values.
The function is called with the name of the attribute and its value. The result of the function is used as the new value in the resulting attribute set.

#### Documentation Link
https://noogle.dev/f/builtins/mapAttrs

#### Signature
mapAttrs :: (String -> Any -> Any) -> AttrSet -> AttrSet

#### Example
```
mapAttrs
    (name: value: name + "-" + value)
    { x = "foo"; y = "bar"; }
=> { x = "x-foo"; y = "y-bar"; }
```

### mapAttrsFlatten

Apply a function to each name and value in an attribute set, collecting the outputs into a list.
The function is called with the name of the attribute and its value. The result of the function is appended to the list of results.

#### Documentation Link
https://noogle.dev/f/lib/misc/mapAttrsFlatten

#### Signature
mapAttrsToList :: (String -> a -> b) -> AttrSet -> [b]

#### Example
```
mapAttrsToList
    (name: value: name + "-" + value)
    { x = "foo"; y = "bar"; }
=> [ "x-foo" "y-bar" ]
```

### mkOverride

Set a priority (integer) for a value which is used to determine which value to keep when merging attribute sets.
- Lower numbers are higher priority.
- Default priority (without any mkOverride or derived functions) is 100.

#### Documentation Link

https://noogle.dev/f/lib/mkOverride (TODO as of 2025-01-12)

#### Signature
mkOverride :: int -> any -> any

#### Example

```
services.nginx.enable = mkOverride 100 true;
```

### mkDefault

`mkOverride 1000`

### mkForce

`mkOverride 50`
