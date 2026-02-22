#!/bin/bash
set -euo pipefail

echo "==> Installing build dependencies..."
sudo apt update
sudo apt install -y git autoconf automake libtool make gcc \
    libncurses5-dev libpam0g-dev libssl-dev

BUILDDIR=$(mktemp -d)
trap 'rm -rf "$BUILDDIR"' EXIT

echo "==> Cloning GNU Screen..."
git clone https://git.savannah.gnu.org/git/screen.git "$BUILDDIR/screen"

cd "$BUILDDIR/screen/src"

echo "==> Running autogen..."
NOCONFIGURE=1 ./autogen.sh

echo "==> Configuring..."
./configure --prefix=/usr/local \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info \
            --enable-pam \
            --with-pty-group=5 \
            --enable-socket-dir=/run/screen \
            --with-system_screenrc=/etc/screenrc

echo "==> Building..."
make -j"$(nproc)"

echo "==> Installing..."
sudo make install

echo "==> Installed: $(/usr/local/bin/screen --version)"

if ! grep -q 'osc 52 on' ~/.screenrc 2>/dev/null; then
    echo 'osc 52 on' >> ~/.screenrc
    echo "==> Added 'osc 52 on' to ~/.screenrc"
fi

echo "==> Done. Restart screen to use the new version."
