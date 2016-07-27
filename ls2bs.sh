#!/bin/bash
#

#----- Config -----
# Backup server
HOST='server.sdfdomain.com'

# Folder you want to snapshot (most probably your home)
SRC="/home/jb"

# Destination on backup server for backups
DEST="/volume1/homes/jb/_snapshots/thinkpad"

# Weeks to keep 
KEEP=5


# ------------- 
LOCALAPPDIR='~/.ls2s'
LASTRUNFILE="$LOCALAPPDIR/lastSnapshot"
DISPLAYNAME="Ls2s snapshot tool"

# Icon for 
ICON="-i $LOCALAPPDIR/icons/Places-network-server-database-icon.png"

# create required files 
if [ ! -d $LOCALAPPDIR ]; then
  mkdir -p $LOCALAPPDIR || exit 1
fi
if [ ! -f $LASTRUNFILE ]; then
  echo 10000 > $LASTRUNFILE || exit 1
fi
NOW=$(date +%s)
LASTRUN=$(cat $LASTRUNFILE)

FORCE=0
ROTATE=1
######if [ -z $1 ]; then
######FORCE=1
######fi

while getopts ":fr" opt; do
  case $opt in 
    f)
      FORCE=1
      ROTATE=0
      ;;
    r)
      FORCE=1
      ROTATE=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Valid options are:
            -f force backup now, no rotate
            -r force and rotate" >&2
      exit 0
      ;;
  esac
done

if [ $(($NOW - $LASTRUN)) -lt $((60 * 60 * 24 *7)) ] && [ $FORCE -eq 0 ]; then
  notify-send $ICON "$DISPLAYNAME" "Backup not Required"
  exit 0
fi

# Wait some time to allow netowrk connnection
#sleep 20
# Exit if syno is down / not in network

#Check network
ping -c 1 $HOST &>/dev/null
#    Success: code 0
#    No reply: code 1
#    Other errors: code 2
res=$?

#echo "ping result: $res"
if [ $res -gt 0 ]; then
  notify-send $ICON "$DISPLAYNAME" "Backup Server appear offline"
  exit 0
fi

#  Rotate - mv backup.0 backup.1
if [ $ROTATE -eq 1 ]; then
    SSHCMD="rm -rf $DEST/weekly.$KEEP"
    for (( i=$KEEP; $i>0; i=$i-1 )) do
      SSHCMD="$SSHCMD && if [ -d $DEST/weekly.$(($i-1)) ];"
      SSHCMD="$SSHCMD then mv $DEST/weekly.$(($i-1)) $DEST/weekly.$i; fi "
    done
    SSHCMD="$SSHCMD &&"
fi

SSHCMD="$SSHCMD if [ ! -d $DEST/weekly.0 ]; then mkdir -p $DEST/weekly.0; fi"

notify-send -t 0 $ICON "$DISPLAYNAME" "Performing Backup.. Please wait"

#echo "$SSHCMD";

ssh $HOST $SSHCMD

renice 19 -p $$ &>/dev/null

RESP=$(rsync -ah --stats --delete --include-from=$LOCALDIR/include --exclude=* \
        --link-dest=$DEST/weekly.1 /home/jb/  $HOST:$DEST/weekly.0/)
#echo "rsync -vah --delete --exclude=* --include-from=$LOCALDIR/include --link-dest=$DEST/weekly.1 /home/jb/  $HOST:$DEST/weekly.0"
echo $NOW > $LASTRUNFILE || exit 1

killall mate-notification-daemon
notify-send -t 6000 $ICON "$DISPLAYNAME" "Backup finished successfully
$RESP"

exit 0
