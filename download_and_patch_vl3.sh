#!/bin/bash

# Provide working directory
CURDIR=`pwd`
WORKING_DIR=`pwd`/working/vl3
mkdir -p ${WORKING_DIR}
DEST_DIR=`pwd`/Out
mkdir -p ${DEST_DIR}
mkdir -p ${DEST_DIR}/icons
mkdir -p ${DEST_DIR}/themes
mkdir -p ${DEST_DIR}/wallpapers

# Download and extract
cd ${WORKING_DIR}
wget http://ftp.vinelinux.org/pub/Vine/Vine-3.2/i386/Vine/RPMS/gnome-themes-2.8.1-0vl1.1.i386.rpm
wget http://ftp.vinelinux.org/pub/Vine/Vine-3.2/i386/Vine/RPMS/metacity-2.8.8-0vl1.i386.rpm
wget http://ftp.vinelinux.org/pub/Vine/Vine-3.2/i386/Vine/RPMS/gnome-icon-theme-2.9.0-0vl1.noarch.rpm
wget http://ftp.vinelinux.org/pub/Vine/Vine-3.2/i386/Vine/RPMS/vine-backgrounds-3.2-0vl1.noarch.rpm

echo "Download done."

for RPM in `ls *.rpm`
do
    rpm2cpio ${RPM} | cpio -idv
done

echo "Extract done."

# Patching
cd ${WORKING_DIR}/usr/share/themes/NeoVine
sed -i "s/GtkTheme=NeoVine/GtkTheme=Clearlooks/g" index.theme
sed -i "s/Name=NeoVine/Name=NeoVine3/g" index.theme
sed -i "s/Name\[ja\]=NeoVine/Name\[ja\]=NeoVine(3)/g" index.theme
sed -i "s/MetacityTheme=NeoVine/MetacityTheme=NeoVine3/g" index.theme
sed -i "s/IconTheme=Smokey-Blue/IconTheme=Smokey-Blue3/g" index.theme


BgNormal=`sed -nE "s/^.*bg\[NORMAL\]\s*=\s\"(#[0-9abcdef]{6})\".*$/\1/p" ./gtk-2.0/gtkrc | head -n 1`
BgSelected=`sed -nE "s/^.*bg\[SELECTED\]\s*=\s\"(#[0-9abcdef]{6})\".*$/\1/p" ./gtk-2.0/gtkrc | head -n 1`
FgNormal=`sed -nE "s/^.*fg\[NORMAL\]\s*=\s\"(#[0-9abcdef]{6})\".*$/\1/p" ./gtk-2.0/gtkrc | head -n 1`
FgSelected=`sed -nE "s/^.*fg\[SELECTED\]\s*=\s\"(#[0-9abcdef]{6})\".*$/\1/p" ./gtk-2.0/gtkrc | head -n 1`
sed -i "s/gtk:bg\[NORMAL\]/${BgNormal}/g" ./metacity-1/metacity-theme-1.xml
sed -i "s/gtk:bg\[SELECTED\]/${BgSelected}/g" ./metacity-1/metacity-theme-1.xml
sed -i "s/gtk:fg\[NORMAL\]/${FgNormal}/g" ./metacity-1/metacity-theme-1.xml
sed -i "s/gtk:fg\[SELECTED\]/${FgSelected}/g" ./metacity-1/metacity-theme-1.xml

cd ${WORKING_DIR}/usr/share/icons/Smokey-Blue
sed -i "s/Name=Smokey-Blue/Name=Smokey-Blue3/g" index.theme
cd ../../

echo "Patching done."

# Move to destination
mv ${WORKING_DIR}/usr/share/icons/Smokey-Blue ${DEST_DIR}/icons/Smokey-Blue3
mv ${WORKING_DIR}/usr/share/themes/NeoVine ${DEST_DIR}/themes/NeoVine3
mv ${WORKING_DIR}/usr/share/themes/NeoVineOld ${DEST_DIR}/themes/NeoVineOld3
mv ${WORKING_DIR}/usr/share/pixmaps/backgrounds/Vine ${DEST_DIR}/wallpapers/Vine3

rm -rf ${WORKING_DIR}

cd ${CURDIR}

echo "All done."