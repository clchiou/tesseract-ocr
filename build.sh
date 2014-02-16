#!/bin/bash
# Copyright (c) 2014 Che-Liang Chiou. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

export LIBLEPT_HEADERSDIR="${NACLPORTS_INCLUDE}/leptonica"
export EXTRA_CONFIGURE_ARGS="--disable-graphics"

# For memory.h
export NACLPORTS_CFLAGS="${NACLPORTS_CFLAGS:-} -I${NACLPORTS_INCLUDE}/glibc-compat"
export NACLPORTS_CXXFLAGS="${NACLPORTS_CXXFLAGS:-} -I${NACLPORTS_INCLUDE}/glibc-compat"

ConfigureStep() {
  Banner "Copy working directory"
  rsync -av --delete ${START_DIR}/ ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_DIR}

  Banner "Run autogen.sh"
  ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_DIR}
  ./autogen.sh

  # XXX Hack for ./configure pixCreate check.
  Banner "Custom fix of ./configure"
  ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_DIR}
  local MORE_LIBS="-lnosys -lz -ljpeg"
  sed --in-place s/'^LIBS="-llept  $LIBS'/"& ${MORE_LIBS}"/ configure

  DefaultConfigureStep
}
