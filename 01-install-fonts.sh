#!/bin/bash -ex

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
rm -f iosevka-comfy
ln -s $SCRIPT_DIR/fonts/iosevka-comfy iosevka-comfy
fc-cache -fv
