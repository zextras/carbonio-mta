#!/bin/bash
#
# SPDX-FileCopyrightText: 2023 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: GPL-2.0-only
#

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <DISTRO>"
  echo "Available DISTROs: ubuntu-focal, ubuntu-jammy, ubuntu-noble, rocky-8, rocky-9"
  exit 1
fi

DISTRO=$1
YAP_FLAGS="-sdc"
YAP_VERSION=1.11

# Validate the DISTRO input
case $DISTRO in
  ubuntu-focal | ubuntu-jammy | ubuntu-noble | rocky-8 | rocky-9)
    echo "Building for DISTRO: $DISTRO"
    ;;
  *)
    echo "Invalid DISTRO: $DISTRO"
    echo "Available DISTROs: ubuntu-focal, ubuntu-jammy, ubuntu-noble, rocky-9"
    exit 1
    ;;
esac

docker run -ti \
  --workdir /project \
  -v "$(pwd):/project" \
  "docker.io/m0rf30/yap-$DISTRO:$YAP_VERSION" \
  build \
  "$DISTRO" \
  /project \
  $YAP_FLAGS
