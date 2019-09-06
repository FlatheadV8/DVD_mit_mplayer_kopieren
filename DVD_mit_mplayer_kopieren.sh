#!/bin/bash

#------------------------------------------------------------------------------#
#
# DVD titelweise rippen
#
# Als Name für die Dateien wird zu erst versucht den DVD-Titel zu ermitteln,
# sollte das versagen, wird versucht die DVD-ID zu ermitteln,
# sollte das auch versagen, dann werden die Dateien einfach "Film" genannt.
#
#------------------------------------------------------------------------------#
### seit Ubuntu 18.04
#
# apt install vlc vlc-l10n libdvd-pkg
# dpkg-reconfigure libdvd-pkg
#
#------------------------------------------------------------------------------#

VERSION="v2019090601"

### FreeBSD
#DVD_DEV="/dev/cd0"
#DVD_DEV="/dev/$(camcontrol devlist | grep -F DVD | awk '{print $NF}' | tr -s '[(,)]' '\n' | grep -Ev '^$|pass[0-9]')"
#
### Linux
#DVD_DEV="/dev/sr0"
#DVD_DEV="/dev/$(grep -F DVD /sys/block/*/device/model | awk -F'/' '{print $4}')"
#
### sollte in FreeBSD _und_ in Linux funktionieren
DVD_DEV="$(ls -1 /dev/dvd* /dev/cd* 2>/dev/null | head -n1)"

DVD_IDENTIFY="$(mplayer dvd:// -dvd-device ${DVD_DEV} -vo null -ao null -identify -frames 0 -novideo -nosound -nocache 2>/dev/null)"
TITEL_NR="$(echo "${DVD_IDENTIFY}" | grep -E '^ID_DVD_TITLE_[0-9]+_LENGTH=' | tr -s '[_.=]' ' ' | awk '{print $6,$4}' | awk '{print $NF}')"
DVD_TITEL="$(echo "${DVD_IDENTIFY}" | grep -E '^ID_DVD_VOLUME_ID=' | tr -s '["=]' ' ' | awk '{print $NF}' | tr -s '[ .]' '_')"
echo "1. DVD_TITEL='${DVD_TITEL}'"

if [ "x${DVD_TITEL}" == "x" ] ; then
        DVD_TITEL="$(echo "${DVD_IDENTIFY}" | grep -E '^ID_DVD_DISC_ID=' | tr -s '["=]' ' ' | awk '{print $NF}' | tr -s '[ .]' '_')"
        echo "2. DVD_TITEL='${DVD_TITEL}'"
        if [ "x${DVD_TITEL}" == "x" ] ; then
                DVD_TITEL="Film"
        fi
fi
echo "3. DVD_TITEL='${DVD_TITEL}'"

mkdir -p "${DVD_TITEL}"
cd "${DVD_TITEL}" || exit

time for T_NR in ${TITEL_NR}
do
        # mplayer dvd://0 -dvd-device ${DVD_DEV} -dumpstream -dumpfile title0.mpg
        echo "mplayer dvd://${T_NR} -mc 0 -forceidx -aspect 16:9 -dumpstream -dumpfile ${DVD_TITEL}_${T_NR}.mpg"
        mplayer dvd://${T_NR} -mc 0 -forceidx -aspect 16:9 -dumpstream -dumpfile ${DVD_TITEL}_${T_NR}.mpg
done

cd -

eject ${DVD_DEV}
