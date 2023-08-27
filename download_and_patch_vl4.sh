#!/bin/bash

# Provide working directory
CURDIR=`pwd`
WORKING_DIR=`pwd`/working/vl4
mkdir -p ${WORKING_DIR}
DEST_DIR=`pwd`/Out
mkdir -p ${DEST_DIR}
mkdir -p ${DEST_DIR}/icons
mkdir -p ${DEST_DIR}/themes
mkdir -p ${DEST_DIR}/wallpapers

# Download and extract
cd ${WORKING_DIR}
wget http://ftp.vinelinux.org/pub/Vine/Vine-4.2/i386/Vine/RPMS/gnome-themes-2.14.2-0vl4.noarch.rpm
wget http://ftp.vinelinux.org/pub/Vine/Vine-4.2/i386/Vine/RPMS/metacity-2.15.13-0vl1.i386.rpm
wget http://ftp.vinelinux.org/pub/Vine/Vine-4.2/i386/Vine/RPMS/gnome-icon-theme-2.14.2-0vl3.noarch.rpm
wget http://ftp.vinelinux.org/pub/Vine/Vine-4.2/i386/Vine/RPMS/vine-backgrounds-3.9-0vl1.noarch.rpm

echo "Download done."

for RPM in `ls *.rpm`
do
    rpm2cpio ${RPM} | cpio -idv
done

echo "Extract done."

# Patching
cd ${WORKING_DIR}/usr/share/themes/ClearVine
sed -i "s/GtkTheme=ClearVine/GtkTheme=Clearlooks/g" index.theme
sed -i "s/Name=ClearVine/Name=ClearVine4/g" index.theme
sed -i "s/Name\[ja\]=クリアーヴァイン/Name\[ja\]=クリアーヴァイン(4)/g" index.theme
sed -i "s/MetacityTheme=ClearVine/MetacityTheme=ClearVine4/g" index.theme
sed -i "s/IconTheme=Vine/IconTheme=Vine4/g" index.theme


BgNormal=`sed -nE "s/^.*bg\[NORMAL\]\s*=\s\"(#[0-9abcdef]{6})\".*$/\1/p" ./gtk-2.0/gtkrc | head -n 1`
BgSelected=`sed -nE "s/^.*bg\[SELECTED\]\s*=\s\"(#[0-9abcdef]{6})\".*$/\1/p" ./gtk-2.0/gtkrc | head -n 1`
FgNormal=`sed -nE "s/^.*fg\[NORMAL\]\s*=\s\"(#[0-9abcdef]{6})\".*$/\1/p" ./gtk-2.0/gtkrc | head -n 1`
FgSelected=`sed -nE "s/^.*fg\[SELECTED\]\s*=\s\"(#[0-9abcdef]{6})\".*$/\1/p" ./gtk-2.0/gtkrc | head -n 1`
sed -i "s/gtk:bg\[NORMAL\]/${BgNormal}/g" ./metacity-1/metacity-theme-1.xml
sed -i "s/gtk:bg\[SELECTED\]/${BgSelected}/g" ./metacity-1/metacity-theme-1.xml
sed -i "s/gtk:fg\[NORMAL\]/${FgNormal}/g" ./metacity-1/metacity-theme-1.xml
sed -i "s/gtk:fg\[SELECTED\]/${FgSelected}/g" ./metacity-1/metacity-theme-1.xml

cd ${WORKING_DIR}/usr/share/icons/Vine
sed -i "s/Name=Vine/Name=Vine4/g" index.theme
sed -i "s/Name\[ja\]=Vine/Name\[ja\]=Vine4/g" index.theme
cd ../../

echo "Patching done."

# Move to destination
mv ${WORKING_DIR}/usr/share/icons/Vine ${DEST_DIR}/icons/Vine4
mv ${WORKING_DIR}/usr/share/themes/ClearVine ${DEST_DIR}/themes/ClearVine4
mv ${WORKING_DIR}/usr/share/themes/OldVine ${DEST_DIR}/themes/OldVine4
mv ${WORKING_DIR}/usr/share/pixmaps/backgrounds/Vine ${DEST_DIR}/wallpapers/Vine4

rm -rf ${WORKING_DIR}

cd ${CURDIR}

echo "All done."