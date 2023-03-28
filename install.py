import shutil
import os
import subprocess as sp
from path import Path

install_dir = Path("JACFileBrowser-build-0.1")
qt_sdk_path = r"C:\SDK\Qt\6.5.0\msvc2019_64"

install_dir.rmtree(ignore_errors=True)
install_dir.mkdir()

out_dirs = [r"build-JACFileBrowser-Desktop_Qt_6_5_0_MSVC2019_64bit-Release"]

for out_dir in out_dirs:
    out_dir = Path(out_dir)

    for f in (x for x in out_dir.listdir() if x.ext in [".dll", ".exe"]):
        print(f)

        if f.basename() == "appJACFileBrowser.exe":
            shutil.copy(out_dir / f.basename(), install_dir / "JACFileBrowser.exe")
        else:
            shutil.copy(out_dir / f.basename(), install_dir)

sp.check_call([os.path.join(qt_sdk_path, "bin", "windeployqt.exe"), 
                install_dir / "JACFileBrowser.exe", 
                "--qmldir", 
                "JACFileBrowser",
                "--no-opengl-sw",
                "--no-translations",
                "--no-virtualkeyboard",
                "--release",
                ])
