import os
import shutil
import subprocess as sp
from pathlib import Path
from argparse import ArgumentParser
import time

# Tested on Windows 10/11 with Visual Studio 2022 and Qt 6.8.0
if os.name != "nt":
    raise RuntimeError("TODO This script is only for Windows")

parser = ArgumentParser()
parser.add_argument("--install_dir", type=str)
parser.add_argument("--install_dir_prefix", type=str, default="JACFileBrowser-release-0.1")
parser.add_argument("--qt_path", type=str, default=r"C:\SDK\Qt\6.8.0\msvc2022_64")
parser.add_argument("--visual_studio_path", type=str, default=r"C:\Program Files\Microsoft Visual Studio\2022\Community")

args = parser.parse_args()

current_dir = Path(__file__).parent.resolve()

if args.install_dir:
    install_dir = Path(args.install_dir)
else:
    install_dir = current_dir / args.install_dir_prefix

print(f"Installing to {install_dir}")

qt_path = Path(args.qt_path)

build_dir = current_dir / "build-JACFileBrowser"

if build_dir.exists():
    print(f"Removing {build_dir}")
    shutil.rmtree(build_dir)

if not os.path.exists(build_dir):
    os.makedirs(build_dir)

print(f"Building in {build_dir}")

os.chdir(build_dir)

vcvars_path = rf"{args.visual_studio_path}\VC\Auxiliary\Build\vcvars64.bat"

sp.check_call(rf""""{vcvars_path}" & cmake -G Ninja -DCMAKE_MAKE_PROGRAM="C:\SDK\Qt\Tools\Ninja\ninja.exe" {current_dir / "JACFileBrowser" / "CMakeLists.txt"} -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="{qt_path}\lib\cmake" -DCMAKE_INSTALL_PREFIX="{install_dir}" """, shell=True)

sp.check_call(rf""""{vcvars_path}" & cmake --build .""", shell=True)
sp.check_call(rf""""{vcvars_path}" & cmake --install .""", shell=True)

shutil.move(install_dir / "bin" / "appJACFileBrowser.exe", install_dir / "appJACFileBrowser.exe")
shutil.rmtree(install_dir / "bin")

sp.check_call([qt_path / "bin" / "windeployqt6.exe", 
            install_dir / "appJACFileBrowser.exe", 
            "--qmldir", 
            "JACFileBrowser",
            "--no-opengl-sw",
            "--no-translations",
            "--no-virtualkeyboard",
            "--release",
            ])

print(f"Installed to {install_dir}")

os.chdir(current_dir)
shutil.rmtree(build_dir)
