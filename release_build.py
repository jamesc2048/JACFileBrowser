import os
import shutil
import subprocess as sp
from pathlib import Path
from argparse import ArgumentParser

# Tested on Windows 10 with Visual Studio 2022 and Qt 6.8.0
if os.name != "nt":
    raise RuntimeError("TODO This script is only for Windows")

parser = ArgumentParser()
parser.add_argument("--install_dir", type=str, default="JACFileBrowser-build-0.1")
parser.add_argument("--qt_path", type=str, default=r"C:\SDK\Qt\6.8.0\msvc2022_64")
parser.add_argument("--visual_studio_path", type=str, default=r"C:\Program Files\Microsoft Visual Studio\2022\Community")

args = parser.parse_args()

current_dir = Path(__file__).parent.resolve()

install_dir = Path(args.install_dir)
qt_path = Path(args.qt_path)

build_dir = current_dir / "build-JACFileBrowser"

if build_dir.exists():
    build_dir.rmtree()

os.path.exists(build_dir) or os.makedirs(build_dir)
os.chdir(build_dir)

vcvars_path = rf"{args.visual_studio_path}\VC\Auxiliary\Build\vcvars64.bat"

sp.check_call(rf""""{vcvars_path}" & cmake -G Ninja -DCMAKE_MAKE_PROGRAM="C:\SDK\Qt\Tools\Ninja\ninja.exe" {current_dir / "JACFileBrowser" / "CMakeLists.txt"} -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="{qt_path}\lib\cmake" -DCMAKE_INSTALL_PREFIX="{install_dir}" """, shell=True)

sp.check_call(rf""""{vcvars_path}" & cmake --build .""", shell=True)
sp.check_call(rf""""{vcvars_path}" & cmake --install .""", shell=True)

sp.check_call([qt_path / "bin" / "windeployqt6.exe", 
            install_dir / "bin" / "appJACFileBrowser.exe", 
            "--qmldir", 
            "JACFileBrowser",
            "--no-opengl-sw",
            "--no-translations",
            "--no-virtualkeyboard",
            "--release",
            ])
