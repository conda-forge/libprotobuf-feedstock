:: Doesn't include gmock or gtest. So, need to get these ourselves for `make check`.
git clone -b release-1.7.0 git://github.com/google/googlemock.git gmock
if errorlevel 1 exit 1
git clone -b release-1.7.0 git://github.com/google/googletest.git gmock/gtest
if errorlevel 1 exit 1

:: We'll do the build twice: once for static and once for shared,
:: since protobuf doesn't support doing both at once.
cd cmake
if errorlevel 1 exit 1

mkdir build-static
if errorlevel 1 exit 1
cd build-static
if errorlevel 1 exit 1

:: Configure and install based on protobuf's instructions and other `bld.bat`s.
cmake -G "NMake Makefiles" ^
         -DCMAKE_BUILD_TYPE=Release ^
         -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
         -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
         -DBUILD_SHARED_LIBS=OFF ^
         -DCMAKE_POSITION_INDEPENDENT_CODE=1 ^
         -Dprotobuf_WITH_ZLIB=ON ^
         ..
if errorlevel 1 exit 1
nmake
if errorlevel 1 exit 1
nmake check
if errorlevel 1 exit 1
nmake install
if errorlevel 1 exit 1

cd ..
if errorlevel 1 exit 1
mkdir build-shared
if errorlevel 1 exit 1
cd build-shared
if errorlevel 1 exit 1

cmake -G "NMake Makefiles" ^
         -DCMAKE_BUILD_TYPE=Release ^
         -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
         -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
         -DBUILD_SHARED_LIBS=ON ^
         -Dprotobuf_WITH_ZLIB=ON ^
         ..
if errorlevel 1 exit 1
nmake
if errorlevel 1 exit 1
nmake check
if errorlevel 1 exit 1
nmake install
if errorlevel 1 exit 1
