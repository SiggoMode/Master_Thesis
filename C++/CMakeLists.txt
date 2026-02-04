cmake_minimum_required(VERSION 3.10)
project(ObjectTracking)

find_package(opencv CONFIG REQUIRED)


add_executable(Main src/main.cpp)
add_executable(Testing src/test.cpp)
add_executable(CalibrateCamera src/calibrate_camera.cpp)
add_executable(CreateBoard src/create_board.cpp)
add_executable(DetectMarkers src/detect_markers.cpp)

target_include_directories(Main PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_include_directories(Testing PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_include_directories(CalibrateCamera PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_include_directories(CreateBoard PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_include_directories(DetectMarkers PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")

target_link_libraries(Main PRIVATE ${OpenCV_LIBS})
target_link_libraries(Testing PRIVATE ${OpenCV_LIBS})
target_link_libraries(CalibrateCamera PRIVATE ${OpenCV_LIBS})
target_link_libraries(CreateBoard PRIVATE ${OpenCV_LIBS})
target_link_libraries(DetectMarkers PRIVATE ${OpenCV_LIBS})