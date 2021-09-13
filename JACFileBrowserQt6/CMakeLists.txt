cmake_minimum_required(VERSION 3.14)

project(JACFileBrowserQt6 VERSION 0.2 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 COMPONENTS Core Quick Concurrent REQUIRED)
find_package(Qt6 COMPONENTS Core Quick Concurrent REQUIRED)

set(PROJECT_SOURCES
        main.cpp
        tablemodelproxy.hpp tablemodelproxy.cpp
        drivesmodel.hpp drivesmodel.cpp
        contentsmodel.hpp contentsmodel.cpp
        utils.hpp utils.cpp
        qml.qrc
)

# TODO always add WIN32 even on Linux/Mac? To hide terminal window
qt_add_executable(JACFileBrowserQt6 WIN32
    MANUAL_FINALIZATION
    ${PROJECT_SOURCES}
)

target_compile_definitions(JACFileBrowserQt6 PUBLIC APP_VERSION="${PROJECT_VERSION}")

target_compile_definitions(JACFileBrowserQt6
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(JACFileBrowserQt6
  PRIVATE Qt6::Core Qt6::Quick)

set_target_properties(JACFileBrowserQt6 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

qt_import_qml_plugins(JACFileBrowserQt6)
qt_finalize_executable(JACFileBrowserQt6)
