cmake_minimum_required(VERSION 3.10)
project(ObjectTracking)

# Tell CMake to use vcpkg toolchain
# (you already pass it via -DCMAKE_TOOLCHAIN_FILE)
find_package(OpenCV CONFIG REQUIRED)

add_executable(ObjectTracking src/test.cpp)

# Link all OpenCV libraries using the variable provided by vcpkg
target_link_libraries(ObjectTracking PRIVATE ${OpenCV_LIBS})
