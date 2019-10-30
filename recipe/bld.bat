:: Setup directory structure per protobuf's instructions.
cd cmake
if errorlevel 1 exit 1

mkdir build-shared
if errorlevel 1 exit 1
cd build-shared
if errorlevel 1 exit 1

:: Configure and install based on protobuf's instructions and other `bld.bat`s.
cmake -G "Ninja" ^
         -DCMAKE_BUILD_TYPE=Release ^
         -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
         -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
         -Dprotobuf_WITH_ZLIB=ON ^
         -Dprotobuf_BUILD_SHARED_LIBS=ON ^
         -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
         ..
if errorlevel 1 exit 1
cmake --build . --target install --config Release
if errorlevel 1 exit 1
