TEMPLATE = subdirs

SUBDIRS += JACFileBrowser \
            ../JACFFmpegLib


JACFileBrowser.depends = ../JACFFmpegLib
