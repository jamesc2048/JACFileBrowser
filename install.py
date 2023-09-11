import shutil
import os
import subprocess as sp
from path import Path

install_dir = Path("JACFileBrowser-build-0.1")
qt_sdk_path = r"C:\SDK\Qt\6.6.0\msvc2019_64"

# read env var Qt6_DIR for Github Actions
build_dir = Path("build-JACFileBrowser")
build_dir.rmtree(ignore_errors=True)
build_dir.mkdir()
build_dir.chdir()

sp.check_call(rf""""C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" & cmake -G Ninja -DCMAKE_MAKE_PROGRAM=C:\SDK\Qt\Tools\Ninja\ninja.exe ..\JACFileBrowser\CMakeLists.txt -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH={qt_sdk_path}\lib\cmake -DCMAKE_INSTALL_PREFIX={install_dir}""", shell=True)

sp.check_call(r""""C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" & cmake --build .""", shell=True)
sp.check_call(r"""cmake --install .""", shell=True)

sp.check_call([Path(qt_sdk_path) / "bin" / "windeployqt6.exe", 
            install_dir / "bin" / "appJACFileBrowser.exe", 
            "--qmldir", 
            "JACFileBrowser",
            "--no-opengl-sw",
            "--no-translations",
            "--no-virtualkeyboard",
            "--release",
            ])
