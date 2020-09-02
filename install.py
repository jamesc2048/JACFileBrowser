import shutil
import os
import subprocess as sp

install_dir = "install"
qt_sdk_path = r"C:\SDK\Qt\5.15.1\msvc2019_64"

try:
    os.removedirs(install_dir)
except:
    pass

try:
    os.mkdir(install_dir)
except:
    pass

out_dirs = [r"build-JACFileBrowser-Desktop_Qt_5_15_1_MSVC2019_64bit-Release\release"]

for out_dir in out_dirs:
    for f in (x for x in os.listdir(out_dir) if os.path.splitext(x)[1] in [".dll", ".exe"]):
        print(f)
        shutil.copy(os.path.join(out_dir, f), install_dir)

sp.check_call([os.path.join(qt_sdk_path, "bin", "windeployqt.exe"), 
                os.path.join(install_dir, "JACFileBrowser.exe"), 
                "--qmldir", 
                "JACFileBrowser",
                "--no-opengl-sw",
                "--no-translations",
                "--no-angle",
                "--no-virtualkeyboard",
                "--release",
                ])
                # TODO use --libdir for ffmpeg dlls?

