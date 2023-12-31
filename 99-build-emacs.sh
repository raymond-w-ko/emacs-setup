#!/bin/bash -ex
cd $HOME/src/emacs
git clean -fxd
./autogen.sh
CFLAGS='-g3 -O2 -gdwarf-2 -fno-optimize-sibling-calls' ./configure --prefix=$HOME/emacs --without-pop --without-imagemagick --without-compress-install -without-dbus \
    --with-gnutls --with-json --with-tree-sitter --without-gconf --with-rsvg --without-gsettings --with-mailutils \
	--with-native-compilation --with-modules --with-xml2 --with-wide-int
make -j32
make install
