:: Setup directory structure per protobuf's instructions.
cd cmake
if errorlevel 1 exit 1

mkdir build-shared
if errorlevel 1 exit 1
cd build-shared
if errorlevel 1 exit 1

:: Configure and install based on protobuf's instructions and other `bld.bat`s.
cmake -G "NMake Makefiles" ^
         -DCMAKE_BUILD_TYPE=Release ^
         -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
         -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
         -Dprotobuf_WITH_ZLIB=ON ^
         -Dprotobuf_BUILD_SHARED_LIBS=ON ^
         -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
         ..
if errorlevel 1 exit 1
nmake
if errorlevel 1 exit 1
nmake check
if errorlevel 1 exit 1

cd ..
if errorlevel 1 exit 1

mkdir build-static
if errorlevel 1 exit 1
cd build-static
if errorlevel 1 exit 1

:: Build static libraries and copy manually
cmake -G "NMake Makefiles" ^
         -DCMAKE_BUILD_TYPE=Release ^
         -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
         -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
         -DCMAKE_RELEASE_POSTFIX="_static" ^
         -Dprotobuf_WITH_ZLIB=ON ^
         -Dprotobuf_BUILD_SHARED_LIBS=OFF ^
         -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
         ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

ren "%LIBRARY_BIN%\protoc.exe" protoc_static.exe
if errorlevel 1 exit 1

@rem now install the shared libraries
cd ..\build-shared
if errorlevel 1 exit 1
nmake install
if errorlevel 1 exit 1
