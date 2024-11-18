cmake_minimum_required(VERSION 3.16)

project(JACFileBrowser VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Qml Concurrent Widgets)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appJACFileBrowser
    main.cpp
)

qt_add_qml_module(appJACFileBrowser
    URI JACFileBrowser
    VERSION ${CMAKE_PROJECT_VERSION}
    SOURCES
    qmliconpainter.hpp qmliconpainter.cpp
    testmodels.hpp testmodels.cpp
    contentsmodel.hpp contentsmodel.cpp
    sortmodel.hpp sortmodel.cpp
    drivesmodel.hpp drivesmodel.cpp
    utilities.hpp utilities.cpp
    QML_FILES
    Main.qml LeftPanel.qml ContentsPanel.qml
    NiceLabel.qml HighlightRectangle.qml PreviewPanel.qml
    PreviewDialog.qml
)

set_target_properties(appJACFileBrowser PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER me.crisafulli.jacfilebrowser
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Keep file and line number info in logs
target_compile_definitions(appJACFileBrowser PUBLIC QT_MESSAGELOGCONTEXT)
target_compile_definitions(appJACFileBrowser PUBLIC APP_VERSION="${CMAKE_PROJECT_VERSION}")
set_target_properties(appJACFileBrowser PROPERTIES VERSION ${CMAKE_PROJECT_VERSION})

if (MSVC)
  target_compile_options(appJACFileBrowser PRIVATE /W4 /WX)
else()
  target_compile_options(appJACFileBrowser PRIVATE -Wall -Wextra -Wpedantic -Werror)
endif()

target_link_libraries(appJACFileBrowser
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Qml Qt6::Concurrent Qt6::Widgets
)

install(TARGETS appJACFileBrowser
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
