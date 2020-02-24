#!/bin/bash

set -ex

if [ "$(uname)" == "Linux" ];
then
    # protobuf uses PROTOBUF_OPT_FLAG to set the optimization level
    # unit test can fail if optmization above 0 are used.
    CPPFLAGS="${CPPFLAGS//-O[0-9]/}"
    CXXFLAGS="${CXXFLAGS//-O[0-9]/}"
    export PROTOBUF_OPT_FLAG="-O2"
    # to improve performance, disable checks intended for debugging
    CXXFLAGS="$CXXFLAGS -DNDEBUG"
elif [ "$(uname)" == "Darwin" ];
then
    # remove pie from LDFLAGS
    LDFLAGS="${LDFLAGS//-pie/}"
fi

# required to pick up conda installed zlib
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"

mkdir build && cd build

cmake -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -Dprotobuf_WITH_ZLIB=ON \
      -Dprotobuf_BUILD_SHARED_LIBS=ON \
      $SRC_DIR/cmake

if [ "${HOST}" == "powerpc64le-conda_cos7-linux-gnu" ]; then
    make -j 2
    make check -j 2
else
    make -j ${CPU_COUNT}
    make check -j ${CPU_COUNT}
fi
make install
