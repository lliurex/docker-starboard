#!/bin/bash
set -e
set -x
if [ -z "$USER" -o -z "$UID" ]; then
    echo "USER NOT DEFINED"
    exit 1
fi
if [ -z "$GROUP" -o -z "$GID" ]; then
    echo "GROUP NOT DEFINED"
    exit 1
fi
#SERVICES="/bin/dbus-uuidgen --ensure;/bin/dbus-daemon --system --fork;/usr/bin/pulseaudio --system --daemonize --high-priority --log-target=syslog --disallow-exit --disallow-module-loading=1"
SERVICES="/bin/dbus-uuidgen --ensure;/bin/dbus-daemon --system --fork;/etc/init.d/starboardservice start;/usr/local/lsadrv/bin/lsadrv_applet_install.sh; bash -x"

rm -f /var/run/dbus/pid > /dev/null 2>&1
sleep 1

IFS=';'
for s in $SERVICES; do
    echo $s
    screen -d -m bash -x -c $s
done
addgroup --quiet --gid ${GID} ${GROUP} || true
adduser  --quiet --home /home/${USER} --shell /bin/false --gecos "UserAccount" --uid ${UID} --ingroup ${GROUP} --disabled-password --disabled-login ${USER} || true
if [ ! -L '/root/lliurex-starboard-storage' ]; then
    ln -s /home/${USER} /root/lliurex-starboard-storage || true
fi
export LANG=es_ES.UTF-8

#screen -d -m 
/usr/local/StarBoardSoftware/StarBoard.sh
chown -R $USER:$GROUP /home/${USER} || true

# Config has root perms
#chown -R $USER:$GROUP /root || true
