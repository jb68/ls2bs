# ss4l
Push Laptop Snapshots to a remote (Backup) Server using rsync and hard links

Initial written to make weekly snapshots of a mate Linux laptop to Synology Disk Station
that is not compatible with back in time.
Direction is from laptop to server because home folder is encripted and laptop is not
available all time for backups.

Based on work done by Mike Rubel http://www.mikerubel.org/computers/rsync_snapshots/

Features:
- work only on sign in
- configurable number of retention weeks
- detect if backup server is in range
- keep a configurable number of snapshots
- notifications on desktop using notify-send

Requirements:
- ssh key-less login on backup server
- rsync installed

Install
- edit s4l.sh script and update config
- run s4l.sh script. This should create the ~/.ss4l dir and create an include file
- copy icons directory to newly created dir
- edit include file and add all directories that you want to snapshot, one directory per line
   ex: Documents/***

ToDo
- Add in progress folder first to deal with failed transfers over slow networks
- demonize
- ncer icons and notifications
- configurable retention policy ex: daily/weekly/monthly
- test and make it compatible with other window managers (kde, cinnamon etc..)
