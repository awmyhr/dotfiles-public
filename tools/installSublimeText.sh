#!/bin/sh

DOWNLOAD='https://download.sublimetext.com/sublime_text_3_build_3126_x64.tar.bz2'
TARBALL='/tmp/sublime-text-3.tar.bz2'

SHORTCUT="[Desktop Entry]
Version=1.0
Type=Application
Name=Sublime Text
GenericName=Text Editor
Comment=Sophisticated text editor for code, markup and prose
Exec=/opt/sublime_text/sublime_text %F
Terminal=false
MimeType=text/plain;
# Icon=/opt/sublime_text_3/Icon/128x128/sublime-text.png
# Icon=sublime-text
Icon=sublime-text-3
Categories=Utilities;Programming;
StartupNotify=true
Actions=Window;Document;
Encoding=UTF-8

[Desktop Action Window]
Name=New Window
Exec=/opt/sublime_text/sublime_text -n
OnlyShowIn=Unity;

[Desktop Action Document]
Name=New File
Exec=/opt/sublime_text/sublime_text --command new_file
OnlyShowIn=Unity;"

curl -L "${DOWNLOAD}" -o "${TARBALL}"
cd /opt
tar -xjf "${TARBALL}"
ln -s /opt/sublime_text_3/sublme_text /usr/local/bin/sublime_text

echo "${SHORTCUT}" > /usr/share/applications/sublime-text-3.desktop

echo "Finish!"