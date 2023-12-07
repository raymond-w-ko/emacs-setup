#!/bin/bash -ex
CHECK=            # Run tests. May fail, this is developement after all.

CLANG=            # Use clang.

GOLD=             # Use the gold linker.

LTO=              # Enable link-time optimization. Still experimental.

JIT="YES"         # Enable native just-in-time compilation with libgccjit available
                  # in core. This compiles only performance critical elisp files.
                  #
                  # To compile all site-lisp on demand (repos/AUR packages,
                  # ELPA, MELPA, whatever), add
                  #    (setq native-comp-deferred-compilation t)
                  # to your .emacs file.
                  # 
                  # And to keep the eln cache clean add
                  #    (setq native-compile-prune-cache t)
                  # to delete old versions.

AOT=              # Compile all elisp files provided by upstream.

TRAMPOLINES="YES" # Compile jitted elisp files with trampolines.

CLI=              # CLI only binary.

GPM=              # Mouse support in Linux console using gpmd.

NOTKIT=           # Use no toolkit widgets. Like B&W Twm (001d sk00l).
                  # Bitmap fonts only, 1337!

PGTK="YES"        # Use native GTK3 build. Supports Wayland, yay! Still
                  # has some problems if running under Xorg. Remember,
                  # this is my personal build file!

GTK3=             # GTK3 old windowing interface.

LUCID=            # Use the lucid, a.k.a athena, toolkit. Like XEmacs, sorta.
                  #
                  # Read https://wiki.archlinux.org/index.php/X_resources
                  # https://en.wikipedia.org/wiki/X_resources
                  # and https://www.emacswiki.org/emacs/XftGnuEmacs
                  # for some tips on using outline fonts with
                  # Xft, if you choose no toolkit or Lucid.

XI2="YES"         # Use Xinput2 support.
                  # https://www.x.org/releases/X11R7.7/doc/inputproto/XI2proto.txt

ALSA=             # Linux sound support.

NOCAIRO=          # Disable here.

XWIDGETS=         # Use GTK+ widgets pulled from webkit2gtk. Usable.

SITTER="YES"      # Use tree-sitter incremental language parsing.

NOSQLITE3=        # Disable sqlite3 support.

DOCS_HTML=        # Generate and install html documentation.

DOCS_PDF=         # Generate and install pdf documentation. You need
                  # a TeX installation. I'm partial to upstream TeXLive.

NOGZ="YES"        # Don't compress .el files. (Gain is neglible, IMHO)

################################################################################

if [[ $GOLD == "YES" && ! $CLANG == "YES" ]]; then
  export LD=/usr/bin/ld.gold
  export CFLAGS+=" -fuse-ld=gold";
  export CXXFLAGS+=" -fuse-ld=gold";
elif [[ $GOLD == "YES" && $CLANG == "YES" ]]; then
  echo "";
  echo "Clang rather uses its own linker.";
  echo "";
  exit 1;
fi

if [[ $CLANG == "YES" ]]; then
  export CC="/usr/bin/clang" ;
  export CXX="/usr/bin/clang++" ;
  export CPP="/usr/bin/clang -E" ;
  export LD="/usr/bin/lld" ;
  export AR="/usr/bin/llvm-ar" ;
  export AS="/usr/bin/llvm-as" ;
  export CCFLAGS+=' -fuse-ld=lld' ;
  export CXXFLAGS+=' -fuse-ld=lld' ;
  makedepends+=( 'clang' 'lld' 'llvm') ;
fi

if [[ $JIT == "YES" ]]; then
  if [[ $CLI == "YES" ]]; then
    depends_nox+=( 'libgccjit' );
  else
    depends+=( 'libgccjit' );
  fi
fi

if [[ ! $CLI == "YES" ]]; then
  depends+=( 'libxi' );
fi

if [[ $CLI == "YES" ]]; then
  depends=("${depends_nox[@]}");
elif [[ $NOTKIT == "YES" ]]; then
  depends+=( 'dbus' 'hicolor-icon-theme' 'libxinerama' 'libxrandr' 'lcms2' 'librsvg' 'libxfixes' 'libxi' 'libsm' 'xcb-util' 'libxcb' );
  makedepends+=( 'xorgproto' );
elif [[ $LUCID == "YES" ]]; then
  depends+=( 'dbus' 'hicolor-icon-theme' 'libxinerama' 'libxfixes' 'lcms2' 'librsvg' 'xaw3d' 'libxrandr' 'libxi' 'libsm' 'xcb-util' 'libxcb' );
  makedepends+=( 'xorgproto' );
elif [[ $GTK3 == "YES" ]]; then
  depends+=( 'gtk3' 'libsm' 'xcb-util' 'libxcb' );
  makedepends+=( 'xorgproto' 'libxi' );
elif [[ $PGTK == "YES" ]]; then
  depends+=( 'gtk3' 'libsm' 'xcb-util' 'libxcb' );
  makedepends+=( 'xorgproto' 'libxi' );
fi

if [[ ! $NOX == "YES" ]] && [[ ! $CLI == "YES" ]]; then
  depends+=( 'libjpeg-turbo' 'libpng' 'giflib' 'libwebp' 'libtiff' 'libxpm');
elif [[ $CLI == "YES" ]]; then
  depends+=();
fi

if [[ $ALSA == "YES" ]]; then
  if [[ $CLI == "YES" ]]; then
    depends_nox+=( 'alsa-lib' );
  else
    depends+=( 'alsa-lib' );
  fi
fi

if [[ ! $NOCAIRO == "YES" ]] && [[ ! $CLI == "YES" ]] && [[ ! $PGTK == "YES" ]] ; then
  depends+=( 'cairo' );
fi

if [[ $XWIDGETS == "YES" ]]; then
  if [[ $LUCID == "YES" ]] || [[ $NOTKIT == "YES" ]] || [[ $CLI == "YES" ]]; then
    echo "";
    echo "";
    echo "Xwidgets support **requires** GTK+3!!!";
    echo "";
    echo "";
    exit 1;
  else
    depends+=( 'webkit2gtk' );
  fi
fi

if [[ $SITTER == "YES" ]]; then
  if [[ $CLI == "YES" ]]; then
    depends_nox+=( 'tree-sitter' );
  else
    depends+=( 'tree-sitter' );
  fi
fi

if [[ $NOSQLITE3 == "YES" ]]; then
  true
else
  if [[ $CLI == "YES" ]]; then
    depends_nox+=( 'sqlite3' );
  else
    depends+=( 'sqlite3' );
  fi
fi

if [[ $GPM == "YES" ]]; then
  if [[ $CLI == "YES" ]]; then
    depends_nox+=( 'gpm' );
  else
    depends+=( 'gpm' );
  fi
fi

if [[ $DOCS_PDF == "YES" ]] && [[ ! -d '/usr/local/texlive' ]]; then
  makedepends+=( 'texlive-core' );
fi

# There is no need to run autogen.sh after first checkout.
# Doing so, breaks incremental compilation.
prepare() {
  cd ~/src/emacs
  git clean -fxd
  [[ -x configure ]] || ( ./autogen.sh git && ./autogen.sh autoconf )
  mkdir -p "build"
}

build() {
  cd ~/src/emacs/build

  local _conf=(
    --prefix=$HOME/emacs
    --sysconfdir=$HOME/emacs/etc
    --libexecdir=$HOME/emacs/usr/lib
    --localstatedir=$HOME/emacs/var
    --mandir=$HOME/emacs/usr/share/man
    --with-gameuser=:games
    --with-modules
    --without-libotf
    --without-m17n-flt
# Beware https://debbugs.gnu.org/cgi/bugreport.cgi?bug=25228
# dconf and gconf break font settings you set in ~/.emacs.
# If you insist you'll need to read that bug report in *full*.
# Good luck!
   --without-gconf
  )

################################################################################

################################################################################

if [[ $CLANG == "YES" ]]; then
  _conf+=( '--enable-autodepend' );
fi

if [[ $LTO == "YES" ]]; then
  _conf+=( '--enable-link-time-optimization' );
fi

if [[ $JIT == "YES" ]]; then
  _conf+=( '--with-native-compilation=yes' );
fi

if [[ $JIT == "YES" ]] && [[ $AOT == "YES" ]]; then
  _conf+=( '--with-native-compilation=aot' );
fi

if [[ ! $JIT == "YES" ]] && [[ ! $AOT == "YES" ]]; then
  _conf+=( '--with-native-compilation=no' );
fi

if [[ $XI2 == "YES" ]]; then
  _conf+=( '--with-xinput2' );
fi

if [[ $CLI == "YES" ]]; then
  _conf+=( '--without-x' '--with-x-toolkit=no' '--without-xft' '--without-lcms2' '--without-rsvg' '--without-jpeg' '--without-gif' '--without-tiff' '--without-png' );
elif [[ $NOTKIT == "YES" ]]; then
  _conf+=( '--with-x-toolkit=no' '--without-toolkit-scroll-bars' '--without-xft' '--without-xaw3d' );
elif [[ $LUCID == "YES" ]]; then
  _conf+=( '--with-x-toolkit=lucid' '--with-xft' '--with-xaw3d' );
elif [[ $GTK3 == "YES" ]]; then
  _conf+=( '--with-x-toolkit=gtk3' '--without-xaw3d' );
elif [[ $PGTK == "YES" ]]; then
  _conf+=( '--with-pgtk' '--without-xaw3d' );
fi

if [[ ! $PGTK == "YES" ]]; then
    _conf+=( '--without-gsettings' ) :
fi

if [[ $NOCAIRO == "YES" || $CLI == "YES" || $NOTKIT == "YES" || $LUCID == "YES" ]]; then
  _conf+=( '--without-cairo' );
fi

if [[ $ALSA == "YES" ]]; then
    _conf+=( '--with-sound=alsa' );
else
    _conf+=( '--with-sound=no' );
fi

if [[ $XWIDGETS == "YES" ]]; then
  _conf+=( '--with-xwidgets' );
fi

if [[ $SITTER == "YES" ]]; then
  _conf+=( '--with-tree-sitter' );
fi

if [[ $NOSQLITE3 == "YES" ]]; then
  _conf+=( '---without-sqlite3' );
fi

if [[ $GPM == "YES" ]]; then
    true
else
  _conf+=( '--without-gpm' );
fi

if [[ $NOGZ == "YES" ]]; then
  _conf+=( '--without-compress-install' );
fi

# ctags/etags may be provided by other packages, e.g, universal-ctags
_conf+=('--program-transform-name=s/\([ec]tags\)/\1.emacs/')

################################################################################

################################################################################

  ../configure "${_conf[@]}"

  # Using "make" instead of "make bootstrap" enables incremental
  # compiling. Less time recompiling. Yay! But you may
  # need to use bootstrap sometimes to unbreak the build.
  # Just add it to the command line.
  #
  # Please note that incremental compilation implies that you
  # are reusing your src directory!
  #

  # You may need to run this if 'loaddefs.el' files become corrupt.
  #cd ~/src/emacs/lisp
  #make autoloads
  #cd ~/src/emacs/build

  if [[ $TRAMPOLINES == "YES" ]] && [[ $JIT == "YES" ]] ; then
    make -j24 trampolines;
  else
    make -j24
  fi

  # Optional documentation formats.
  if [[ $DOCS_HTML == "YES" ]]; then
    make html;
  fi
  if [[ $DOCS_PDF == "YES" ]]; then
    make pdf;
  fi

}

package() {
  cd ~/src/emacs/build

  pkgdir=
  make DESTDIR="$pkgdir" install

  # Install optional documentation formats
  if [[ $DOCS_HTML == "YES" ]]; then make DESTDIR="$pkgdir" install-html; fi
  if [[ $DOCS_PDF == "YES" ]]; then make DESTDIR="$pkgdir" install-pdf; fi
}

cleanup_user_caches() {
  rm -rf $HOME/.cache/emacs/eln-cache/
  rm -rf $HOME/.emacs.d/eln-cache/
}

rm -rf $HOME/emacs
(prepare)
(build)
(package)
(cleanup_user_caches)
