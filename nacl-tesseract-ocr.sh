#!/bin/bash
#
# Copyright (c) 2013 Che-Liang Chiou. All rights reserved.
# Use of this source code is governed by the GNU General Public License
# as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#

source pkg_info
source ../common.sh

export CFLAGS="${CFLAGS:-} -I=/usr/include/glibc-compat"
export CXXFLAGS="${CXXFLAGS:-} -I=/usr/include/glibc-compat \
                 -I$(realpath ../k2pdfopt/include_mod) \
                 -I$(realpath ../k2pdfopt/tesseract_mod)"
export LIBLEPT_HEADERSDIR=${NACLPORTS_INCLUDE}/leptonica
export EXTRA_CONFIGURE_ARGS="--disable-graphics"

CustomFixupOfConfigureScript() {
  ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_DIR}
  # Hack for pixCreate check.
  sed --in-place s'/^LIBS="-llept  $LIBS"/LIBS="-llept  $LIBS  -lnacl-mounts -lnosys -lstdc++ -lpthread -lz -ljpeg"/' \
    configure
}

CustomPackageInstall() {
  DefaultPreInstallStep
  DefaultSyncSrcStep
  DefaultPreConfigureStep
  CustomFixupOfConfigureScript
  DefaultConfigureStep
  DefaultBuildStep
  DefaultInstallStep
  DefaultCleanUpStep
}

CustomPackageInstall
