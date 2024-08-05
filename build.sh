#!/bin/bash

# Set the name of the distro
DISTRO_NAME="oxide"
# Set the Debian version
DEBIAN_VERSION="bookworm"
# Set image version
VERSION="1.0.0-alpha"
# Set image publisher
PUBLISHER="arshavir mirzakhani - github.com/arshavirmirzakhani"
# Set boot logo
BOOT_LOGO="assets/logo.png"
# Set KDE logo
KDE_LOGO="assets/logo.png"
# Set background image
BACKGROUND_IMAGES="assets/wallpapers"

# Set the architecture array
declare -a archs=("i386" "amd64")

for arch in "${archs[@]}" 
do
  mkdir -p $DISTRO_NAME-$arch
  cd $DISTRO_NAME-$arch
  # Run lb config with arguments
  lb config \
    --architecture $arch \
    --distribution $DEBIAN_VERSION \
    --mirror-bootstrap http://deb.debian.org/debian/ \
    --mirror-chroot http://deb.debian.org/debian/ \
    --mirror-binary http://deb.debian.org/debian/ \
    --iso-application $DISTRO_NAME-$VERSION \
    --iso-preparer $DISTRO_NAME-$VERSION \
    --iso-publisher $PUBLISHER \
    --iso-volume $DISTRO_NAME-$VERSION \
    --system normal
  
    # Customize live build config
  cat ../packages.txt >> config/package-lists/desktop.list.chroot

  cp -a ../chroot/* config/hooks/normal/
  
  # Run lb build to create the live image
  lb build

  mv live-image-$arch.hybrid.iso $DISTRO_NAME-$VERSION-$arch.iso

  cd ..
done

