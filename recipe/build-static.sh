#!/bin/bash

set -euo pipefail

mkdir -p ${PREFIX}/lib
ls -l ./src/.libs/libproto*.a
cp ./src/.libs/libproto*.a ${PREFIX}/lib/
