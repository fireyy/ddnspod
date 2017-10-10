#!/bin/ash

START=99
STOP=99
. /etc/misstar/scripts/MTbase

start() {
        wget $1 -O /tmp/$2.mt >/dev/null 2>&1
        if [ $? -ne 0 ];then
                echo -e "1801\c"
                exit
        fi
        cd /tmp
        unzip -o /tmp/$2.mt -d /tmp >/dev/null 2>&1

        if [ $? -ne 0 ];then
                echo -e "1802\c"
                exit
        fi
        cp -rf /tmp/$2 /etc/misstar/applications
        chmod +x -R /etc/misstar/applications/$2/bin/*
        chmod +x /etc/misstar/applications/$2/script/*
        . /etc/misstar/applications/$2/installed/json.conf
        echo >> /etc/misstar/scripts/file_check
        cat /etc/misstar/applications/$2/installed/filecheck.conf >> /etc/misstar/scripts/file_check
        echo >> /etc/config/misstar
        cat /etc/misstar/applications/$2/installed/misstar >> /etc/config/misstar
        echo >> /etc/misstar/scripts/Monitor
        cat /etc/misstar/applications/$2/installed/monitor >> /etc/misstar/scripts/Monitor
        echo "/etc/misstar/applications/$2/script/$2 restart" >> /etc/misstar/scripts/Dayjob
        cp -rf /etc/misstar/applications/$2/installed/*.png /etc/misstar/luci/img/
        lua /etc/misstar/scripts/applist.lua add '{title="'$title'",icon="'$icon'",href="'$href'",version="'$version'",versionlog="'$versionlog'",describe="'$describe'"}'
        if [ $? -ne 0 ];then
                echo -e "1803\c"
                exit
        fi
        /etc/misstar/scripts/file_check
        rm -rf /etc/misstar/applications/$2/installed/
        rm -rf /tmp/luci-indexcache /tmp/luci-modulecache/*
        rm -rf /tmp/$2
        rm -rf /tmp/$2.mt
}

test() {
    # start https://github.com/fireyy/ddnspod/blob/master/ddnspod.zip?raw=true ddnspod
    echo $1 $2
}