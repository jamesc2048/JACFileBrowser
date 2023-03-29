import shutil
import os
import subprocess as sp
from path import Path

install_dir = Path("JACFileBrowser-build-0.1")
qt_sdk_path = r"C:\SDK\Qt\6.5.0\msvc2019_64"

# read env var Qt6_DIR for Github Actions
build_dir = Path("build-JACFileBrowser")
build_dir.rmtree(ignore_errors=True)
build_dir.mkdir()
build_dir.chdir()

sp.check_call(r""""C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" cmake -G Ninja -DCMAKE_MAKE_PROGRAM=C:\SDK\Qt\Tools\Ninja\ninja.exe ..\JACFileBrowser\CMakeLists.txt -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=C:\SDK\Qt\6.5.0\msvc2019_64\lib\cmake""", shell=True)


install_dir.rmtree(ignore_errors=True)
install_dir.mkdir()

for f in (x for x in build_dir.listdir() if x.ext in [".dll", ".exe"]):
    print(f)

    if f.basename() == "appJACFileBrowser.exe":
        shutil.copy(build_dir / f.basename(), install_dir / "JACFileBrowser.exe")
    else:
        shutil.copy(build_dir / f.basename(), install_dir)

sp.check_call([Path(qt_sdk_path) / "bin" / "windeployqt.exe", 
            install_dir / "JACFileBrowser.exe", 
            "--qmldir", 
            "JACFileBrowser",
            "--no-opengl-sw",
            "--no-translations",
            "--no-virtualkeyboard",
            "--release",
            ])
