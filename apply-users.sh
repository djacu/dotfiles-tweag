#!/bin/sh
pushd ~/dotfiles
nix build .#homeManagerConfigurations.$USER.activationPackage
./result/activate
popd
