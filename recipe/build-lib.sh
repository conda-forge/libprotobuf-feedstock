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

# Setup directory structure per protobuf's instructions.
cd cmake

if [[ "$PKG_NAME" == "libprotobuf-static" ]]; then
    export CF_SHARED=OFF
    mkdir build-static
    cd build-static
else
    export CF_SHARED=ON
    mkdir build-shared
    cd build-shared
fi

cmake -G "Ninja" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -Dprotobuf_WITH_ZLIB=ON \
    -Dprotobuf_BUILD_SHARED_LIBS=$CF_SHARED \
    ..

cmake --build .

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
    ninja check
fi

cmake --install .
