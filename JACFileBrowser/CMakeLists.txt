cmake_minimum_required(VERSION 3.16)

project(JACFileBrowser VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Qml Concurrent)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appJACFileBrowser
    main.cpp
    testmodels.hpp testmodels.cpp
    contentsmodel.hpp contentsmodel.cpp
    sortmodel.hpp sortmodel.cpp
    utilities.hpp utilities.cpp
)

qt_add_qml_module(appJACFileBrowser
    URI JACFileBrowser
    VERSION 0.1
    QML_FILES Main.qml
)

set_target_properties(appJACFileBrowser PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appJACFileBrowser
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Qml Qt6::Concurrent
)

install(TARGETS appJACFileBrowser
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
