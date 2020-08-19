#!/bin/bash
CWD=/run/media/caos/backup/
CWD=$PWD
REPOSITORY=$CWD/borg



mountPart=$CWD/mount/
pwdId=$(stat -c%d $CWD)
mountId=$(stat -c%d "${mountPart}")
if (( pwdId == mountId ))
then
    echo "not mounted"
    read -sp 'Password: ' passvar
    export BORG_PASSPHRASE=$passvar
    borg mount $REPOSITORY $CWD/mount/
    backup_exit=$?

else
    echo "mounted"
    borg umount $CWD/mount/
    prune_exit=$?

fi

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -ne 0 ];
then
    #echo "Errore"
    read -n1 -r -p "Press any key to continue..." key
fi


exit ${global_exit}
