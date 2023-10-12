#!/bin/bash
set -ex

if [[ "$(uname)" == "Linux" ]]; then
    # protobuf uses PROTOBUF_OPT_FLAG to set the optimization level
    # unit test can fail if optmization above 0 are used.
    CPPFLAGS="${CPPFLAGS//-O[0-9]/}"
    CXXFLAGS="${CXXFLAGS//-O[0-9]/}"
    export PROTOBUF_OPT_FLAG="-O2"
    # to improve performance, disable checks intended for debugging
    CXXFLAGS="$CXXFLAGS -DNDEBUG"
elif [[ "$(uname)" == "Darwin" ]]; then
    # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
    # remove pie from LDFLAGS
    LDFLAGS="${LDFLAGS//-pie/}"
    # CoreFoundation is needed as least as of libprotobuf>=4.23.X
    LDFLAGS="${LDFLAGS} -framework CoreFoundation"
fi

# required to pick up conda installed zlib
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"

# delete vendored gtest to force protobuf_USE_EXTERNAL_GTEST to work;
# this gets run twice (second time for libprotobuf-static), so don't fail
rm -rf ./third_party/googletest | true

if [[ "$PKG_NAME" == "libprotobuf-static" ]]; then
    export CF_SHARED=OFF
    mkdir build-static
    cd build-static
else
    export CF_SHARED=ON
    mkdir build-shared
    cd build-shared
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
    export CMAKE_ARGS="${CMAKE_ARGS} -Dprotobuf_BUILD_TESTS=OFF"
fi

cmake -G "Ninja" \
    ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=17 \
    -Dprotobuf_ABSL_PROVIDER="package" \
    -Dprotobuf_BUILD_SHARED_LIBS=$CF_SHARED \
    -Dprotobuf_JSONCPP_PROVIDER="package" \
    -Dprotobuf_USE_EXTERNAL_GTEST=ON \
    -Dprotobuf_WITH_ZLIB=ON \
    ..

cmake --build .

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
    ctest --progress --output-on-failure
fi

cmake --install .
