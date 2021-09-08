import shutil
import os
import subprocess as sp

install_dir = "install"
qt_sdk_path = r"C:\SDK\Qt\6.2.0\msvc2019_64"

try:
    os.removedirs(install_dir)
except:
    pass

try:
    os.mkdir(install_dir)
except:
    pass

out_dirs = [r"build-JACFileBrowserQt6-Desktop_Qt_6_2_0_MSVC2019_64bit-Release"]

for out_dir in out_dirs:
    for f in (x for x in os.listdir(out_dir) if os.path.splitext(x)[1] in [".dll", ".exe"]):
        print(f)
        shutil.copy(os.path.join(out_dir, f), install_dir)

sp.check_call([os.path.join(qt_sdk_path, "bin", "windeployqt.exe"), 
                os.path.join(install_dir, "JACFileBrowserQt6.exe"), 
                "--qmldir", 
                "JACFileBrowserQt6",
                "--no-opengl-sw",
                "--no-translations",
                "--no-virtualkeyboard",
                "--release",
                ])
