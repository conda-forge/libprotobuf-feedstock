:: Setup directory structure per protobuf's instructions.
cd cmake

mkdir build-shared
cd build-shared

:: Configure and install based on protobuf's instructions and other `bld.bat`s.
cmake -G "Ninja" ^
         -DCMAKE_BUILD_TYPE=Release ^
         -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
         -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
         -Dprotobuf_WITH_ZLIB=ON ^
         -Dprotobuf_BUILD_SHARED_LIBS=ON ^
         -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
         ..
if %ERRORLEVEL% neq 0 exit 1
cmake --build . --target install --config Release
if %ERRORLEVEL% neq 0 exit 1
