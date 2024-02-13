#!/bin/bash

EXT_LIST=(
appindicatorsupport@rgcjonas.gmail.com
Vitals@CoreCoding.com
gsconnect@andyholmes.github.io
blur-my-shell@aunetx
just-perfection-desktop@just-perfection
status-area-horizontal-spacing@mathematical.coffee.gmail.com
top-bar-organizer@julian.gse.jsts.xyz
user-theme@gnome-shell-extensions.gcampax.github.com
clipboard-indicator@tudmotu.com
color-picker@tuberry
apps-menu@gnome-shell-extensions.gcampax.github.com
background-logo@fedorahosted.org
launch-new-instance@gnome-shell-extensions.gcampax.github.com
places-menu@gnome-shell-extensions.gcampax.github.com
window-list@gnome-shell-extensions.gcampax.github.com
)

GN_CMD_OUTPUT=$(gnome-shell --version)
GN_SHELL=${GN_CMD_OUTPUT:12:2}
for i in "${EXT_LIST[@]}"
do
    VERSION_LIST_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=${i}" | jq '.extensions[] | select(.uuid=="'"${i}"'")') 
    VERSION_TAG="$(echo "$VERSION_LIST_TAG" | jq '.shell_version_map |."'"${GN_SHELL}"'" | ."pk"')"
    wget -O "${i}".zip "https://extensions.gnome.org/download-extension/${i}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force "${i}".zip
    rm "${i}".zip
done

dconf load /org/gnome/shell/extensions/ < "./extensions.conf"
