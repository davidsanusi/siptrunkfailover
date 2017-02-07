SIPGW="<SIPGW_IPADDRESS>"
BACKUPGW="<BACKUPGW_IPADDRESS>"
INTERNET="8.8.8.8" # Any ALWAYS reachable internet client will suffice here
INT0=/etc/sysconfig/network-scripts/ifcfg-eth0
INT1=/etc/sysconfig/network-scripts/ifcfg-eth1
LOGFILE=/root/sipTrunkStatus.log
MYHOST=`hostname`

function activateBackupLink() {
        # This block executes if SIPGW is NOT reachable
        sed -i 's/#//' $INT0                                            # Uncomment #<BACKUPGW_IPADDRESS> in $INT0
        sed -i '/GATEWAY/s/^#*/#/' $INT1                                # Comment out <SIPGW_IPADDRESS> in $INT1
        service network restart > /dev/null                             # Restart network service
        TIMECHECK=$(echo `date +%b\ %d\ %Y\ %r`)
        echo "$TIMECHECK: $MYHOST Failover completed. $BACKUPGW is now the active gateway." >> $LOGFILE
}

function activateMainLink() {
        # This block executes SIPGW is reachable
        sed -i '/ GATEWAY /s/^/#/' $INT0                                # Comment <BACKUPGW_IPADDRESS> in $INT0
        sed -i 's/#//' $INT1                                            # Uncomment <SIPGW_IPADDRESS> in INT1
        service network restart > /dev/null                             # Restart network service
        TIMECHECK=$(echo `date +%b\ %d\ %Y\ %r`)
        echo "$TIMECHECK: $MYHOST Link restored. $SIPGW is now reachable." >> $LOGFILE
}

function checkSipGateway() {
        ping -c 5 $SIPGW > /dev/null
        return $?
}

function checkInternet() {
        ping -c 5 $INTERNET > /dev/null
        return $?
}

function linkUp() {
        TIMECHECK=$(echo `date +%b\ %d\ %Y\ %r`)
        echo "$TIMECHECK: $MYHOST Link status check... $SIPGW is reachable." >> $LOGFILE
}

function linkDown() {
        TIMECHECK=$(echo `date +%b\ %d\ %Y\ %r`)
        echo "$TIMECHECK: $MYHOST Link status check... $SIPGW is still down but backup $BACKUPGW is active." >> $LOGFILE
}

# Check if SIPGW is up and log it
if $( checkSipGateway )
        then
        linkUp
        # exit 0
fi

# Check if SIPGW is down but internet is reachable. Meaning that backup link is active and log it.
if $( ! checkSipGateway ) && $(checkInternet)
        then
        linkDown
        exit 0
fi

# Check if SIPGW is down and activate backup link
if $( ! checkSipGateway )
        then
        activateBackupLink
        exit 0
fi

# Check if SIPGW is up but internet is still reachable. Meaning that backup link is still active. Then activate main link
if $( checkSipGateway ) && $( checkInternet )
        then
        activateMainLink
        exit 0
fi
### END ###
