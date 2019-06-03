mkdir -p build_cmake
cd build_cmake
cmake -DCMAKE_TOOLCHAIN_FILE=../wasi-toolchain.cmake ..
make