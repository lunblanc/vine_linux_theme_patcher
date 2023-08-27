#!/bin/bash

# Provide working directory
CURDIR=`pwd`
WORKING_DIR=`pwd`/working/vl5
mkdir -p ${WORKING_DIR}
DEST_DIR=`pwd`/Out
mkdir -p ${DEST_DIR}
mkdir -p ${DEST_DIR}/icons
mkdir -p ${DEST_DIR}/themes
mkdir -p ${DEST_DIR}/wallpapers

# Download and extract
cd ${WORKING_DIR}
wget http://ftp.vinelinux.org/pub/Vine/Vine-5.2/i386/Vine/RPMS/gnome-themes-2.26.3.1-1vl5.noarch.rpm
wget http://ftp.vinelinux.org/pub/Vine/Vine-5.2/i386/Vine/RPMS/metacity-2.26.0-4vl5.i386.rpm
wget http://ftp.vinelinux.org/pub/Vine/Vine-5.2/i386/Vine/RPMS/gnome-icon-theme-2.26.0-1vl5.noarch.rpm
wget http://ftp.vinelinux.org/pub/Vine/Vine-5.2/i386/Vine/RPMS/vine-backgrounds-4.0-1vl5.noarch.rpm

echo "Download done."

for RPM in `ls *.rpm`
do
    rpm2cpio ${RPM} | cpio -idv
done

echo "Extract done."

# Patching
cd ${WORKING_DIR}/usr/share/themes/ClearVine
sed -i "s/GtkTheme=ClearVine/GtkTheme=Clearlooks/g" index.theme
sed -i "s/Name=ClearVine/Name=ClearVine5/g" index.theme
sed -i "s/Name\[ja\]=クリアーヴァイン/Name\[ja\]=クリアーヴァイン(5)/g" index.theme
sed -i "s/MetacityTheme=ClearVine/MetacityTheme=ClearVine5/g" index.theme
sed -i "s/IconTheme=Vine/IconTheme=Vine5/g" index.theme


BgNormal=`sed -nE "s/^.*nbg_color:(#[0-9abcdef]{6}).*$/\1/p" ./gtk-2.0/gtkrc`
BgSelected=`sed -nE "s/^.*nselected_bg_color:(#[0-9abcdef]{6}).*$/\1/p" ./gtk-2.0/gtkrc`
FgNormal=`sed -nE "s/^.*\"fg_color:(#[0-9abcdef]{6}).*$/\1/p" ./gtk-2.0/gtkrc`
sed -i "s/gtk:bg\[NORMAL\]/${BgNormal}/g" ./metacity-1/metacity-theme-1.xml
sed -i "s/gtk:bg\[SELECTED\]/${BgSelected}/g" ./metacity-1/metacity-theme-1.xml
sed -i "s/gtk:fg\[NORMAL\]/${FgNormal}/g" ./metacity-1/metacity-theme-1.xml

cd ${WORKING_DIR}/usr/share/icons/Vine
sed -i "s/Name=Vine/Name=Vine5/g" index.theme
cd ../../

echo "Patching done."

# Move to destination
mv ${WORKING_DIR}/usr/share/icons/Vine ${DEST_DIR}/icons/Vine5
mv ${WORKING_DIR}/usr/share/themes/ClearVine ${DEST_DIR}/themes/ClearVine5
mv ${WORKING_DIR}/usr/share/themes/OldVine ${DEST_DIR}/themes/OldVine5
mv ${WORKING_DIR}/usr/share/pixmaps/backgrounds/Vine ${DEST_DIR}/wallpapers/Vine5

rm -rf ${WORKING_DIR}

cd ${CURDIR}

echo "All done."