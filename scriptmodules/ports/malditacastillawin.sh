#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="malditacastillawin"
rp_module_desc="Maldita Castilla by Locomalito"
rp_module_help=""
rp_module_licence="CC https://locomalito.com/maldita_castilla.php"
rp_module_section="exp"
rp_module_flags="!all rpi4"

function depends_malditacastillawin() {
    if ! rp_isInstalled "wine" ; then
        md_ret_errors+=("Sorry, you need to install the wine scriptmodule")
        return 1
    fi
}

function install_bin_malditacastillawin() {
    echo "Downloading Maldita Castilla to $md_inst"
    downloadAndExtract "https://locomalito.com/juegos/Maldita_Castilla.zip" "$md_inst"
}

function configure_malditacastillawin() {
    local system="malditacastillawin"
    local malditacastillawin="$romdir/wine/Maldita Castilla (Locomalito).sh"
    
    touch config.ini
    mkUserDir "$md_conf_root/$md_id"
    moveConfigFile "$md_inst/config.ini" "$md_conf_root/$md_id/config.ini"

    #
    # Add Maldita Castilla entry to Wine roms directory in Emulation Station
    #
    cat > "$malditacastillawin" << _EOFMC_
#!/bin/bash
xset -dpms s off s noblank
cd "$md_inst"
matchbox-window-manager &
WINEDEBUG=-all LD_LIBRARY_PATH="/opt/retropie/supplementary/mesa/lib/" setarch linux32 -L /opt/retropie/emulators/wine/bin/wine '$md_inst/Maldita Castilla.exe'
_EOFMC_
    chown $user:$user "$malditacastillawin"
    chmod a+x "$malditacastillawin"
}
