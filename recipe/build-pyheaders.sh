#!/bin/bash

set -exuo pipefail

rsync -a --prune-empty-dirs --include '*/' --include '*.h' --exclude '*' python/ $PREFIX/include/
