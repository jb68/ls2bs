# ls2s
Laptop Snapshots to (Backup) Server using rsync and hard links

Initiall written to back-up snapshots of a mate linux laptop to a Synology Disk Station.
Based on work done by Mike Rubel http://www.mikerubel.org/computers/rsync_snapshots/

Features:
- work only on sign in
- detect if backup server is in range
- keep a configurable number of stapshots
- show status on desktop using notify-send

Requirments:
- ssh keyless login on backup server
- rsync installed

Install 
- run mkdir ~/.ls2s
- copy icons directory to newly created dir
