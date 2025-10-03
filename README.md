# crocuda.nixos - Trivial server config modules.

A set of **nixos modules** which provide trivial configuration
for servers.

For **paranoids** and **hypochondriacs**.

## Configuration directory architecture.

This flake makes use of [nixos-tidy](https://github.com/pipelight/nixos-tidy) to recursively import every file from the `default.nix`.
So you won't encounter any `imports=[]`.

## Installation and Usage (Flake)

Add the repo url to your flake inputs.

```nix
# flake.nix
inputs = {
  normal = {
      url = "github:pipelight/crocuda.nixos";
  };
};
```

Add the module to your system configuration.

```nix
# flake.nix
nixosConfigurations = {
  # CrocudaVM config
  my_machine = pkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
        # Import the module and the related configuration
        inputs.crocuda.nixosModules.default
        ./crocuda.nix
    ];
  };
};
```

See `option.nix` for available options.

```nix
# crocuda.nix
{
  config,
  pkgs,
  inputs,
  ...
}: {

  services.crocuda = {
    users = ["anon"]; # Will create user if not created.
    base.enable = true;

    keyboard.layout = "colemak-dh";

    # Terminal stuffs
    terminal = {
      shell = {
        fish.enable = true;
      };
      editor = {
        vim.enable = true;
        nvchad.enable = true;
        nvchad-ide.enable = true;
      };
      file_manager = {
        yazi.enable = true;
      };
    };

    finance = {
      monero.enable = false;
      darkfi.enable = false;
    };
  };
}
```
