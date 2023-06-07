# nix-cpp-hello
This project is an example of how to set up a simple C++20 project with Nix and clangd. It may be useful if you're trying to develop with C++ on NixOS.

For more background, check out this [NixOS Discourse thread](https://discourse.nixos.org/t/nixos-simple-c-development-in-vscode/28755).

# VSCode C++ Development Workflow on NixOS
Follow the instructions below to set up a basic C++ project in VS Code on NixOS. You can clone this repo and work within it, or use it as a reference and write Nix expressions for your own project.

## Prerequisites
This example assumes you're using the [clangd](https://clangd.llvm.org/) language server and Nix flakes.

First set up VS Code with clangd and direnv. The clangd extension will provide syntax highlighting, autocomplete, and other language server functionality. The direnv extension will make development dependencies from your Nix devShell (like clangd from `clang-tools`) available within VSCode.

**NixOS VSCode configuration.nix example (without home-manager)**:
```nix
{ config, pkgs, ... }:
{
  # ...

  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
      ];
    })
  ];
}
```

**home-manager VSCode configuration example**:
```nix
{ config, pkgs, ... }:
{
  # ...

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      llvm-vs-code-extensions.vscode-clangd
      mkhl.direnv
    ];
  };
}
```

## Configuring clangd
clangd requires a configuration file called [compile-commands.json](https://clangd.llvm.org/installation.html#compile_commandsjson) to help understand your source code. The standard recommendations to generate this file (like the `bear` tool) don't work on NixOS. Thankfully, [mini_compile_commands](https://github.com/danielbarter/mini_compile_commands) can help us automatically generate a `compile-commands.json` file.

The default devShell in this repo's flake provides an environment with mini-compile-commands.

**To generate `compile-commands.json`, run the following in the project directory**:
```bash
$ nix develop
$ mini_compile_commands_server.py &
$ pid=$!
$ make
$ kill -s SIGINT $pid
```

You can test that everything works by opening this project folder in VS Code, and verifying that there are no red squiggles or errors in the `hello.cpp` file.

Repeat this step whenever your dependencies or compile flags change.

## Acknowledgements
[Daniel Barter](https://github.com/danielbarter) created the [mini_compile_commands](https://github.com/danielbarter/mini_compile_commands) project, and provided very helpful guidance on the NixOS discourse. Thanks Daniel!

The `hello.cpp` example file is copied from [LearnCPP's C++20 compatibility check](https://www.learncpp.com/cpp-tutorial/configuring-your-compiler-choosing-a-language-standard/#example20). If you're just getting started with C++, LearnCPP is a great resource.
