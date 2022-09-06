@echo on

if "%PKG_NAME%"=="libprotobuf-static" (
    set CF_SHARED=OFF
    mkdir build-static
    cd build-static
) else (
    set CF_SHARED=ON
    mkdir build-shared
    cd build-shared
)

:: Configure and install based on protobuf's instructions and other `bld.bat`s.
cmake -G "Ninja" ^
         -DCMAKE_BUILD_TYPE=Release ^
         -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
         -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
         -Dprotobuf_WITH_ZLIB=ON ^
         -Dprotobuf_BUILD_SHARED_LIBS=%CF_SHARED% ^
         -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
         ..
if %ERRORLEVEL% neq 0 exit 1
cmake --build . --target install --config Release
if %ERRORLEVEL% neq 0 exit 1
