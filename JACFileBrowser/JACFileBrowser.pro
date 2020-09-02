QT += quick gui

CONFIG += c++17 qtquickcompiler

CONFIG(release, debug|release): {
    message("Release mode")
    CONFIG += ltcg
}
else {
    message("Debug mode")
}

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        backend.cpp \
        contentsmodel.cpp \
        main.cpp \
        tabsmodel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    backend.hpp \
    contentsmodel.hpp \
    tabsmodel.hpp

VERSION = 0.1.0.0

win32: {
    RC_ICONS = icons/appIcon.ico
}

msvc {
    message("MSVC opts")
    QMAKE_CXXFLAGS += /WX
}
else {
    QMAKE_CXXFLAGS += -Werror
}
