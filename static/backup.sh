#!/bin/bash
CWD=$PWD
REPOSITORY=$CWD/borg
logfile=$CWD/log/`hostname`_`date '+%Y-%m-%d_%H-%M-%S'`.txt
echo "------------------------------------------------------------------------------">>$logfile
echo "Inizio Backup "`date`>>$logfile
echo "------------------------------------------------------------------------------">>$logfile
read -sp 'Password: ' passvar                           \
export BORG_PASSPHRASE=$passvar
echo

borg create                                             \
    --verbose                                           \
    --list                                              \
    --stats                                             \
    --compression lz4                                   \
    $REPOSITORY::'{hostname}-{now:%Y-%m-%d_%H-%M}'      \
    /home/caos/                                         \
    /media/Media/                                       \
    /media/Dati/                                        \
    /etc/fstab                                          \
    --exclude '/media/Media/bittorrent'                 \
    --exclude '/media/Media/Download'                   \
    --exclude '/media/Dati/Backup'                      \
    --exclude '/media/Media/Musica'                     \
    --exclude '/media/Media/.Trash-1000'                \
    --exclude '/media/Dati/.Trash-1000'                 \
    --exclude '/home/caos/.aMule'                       \
2>&1                                                    \
| tee -a $logfile

backup_exit=${PIPESTATUS[0]}

#File modificati
grep -v -e ^U.* -e^d.* $logfile > tmp_file
#sed -i -e 1,3d tmp_file                             #cancello le prime 3 righe
sed -i '/\//!d' tmp_file                             #cancello tutte le righe che non contengono '/'

echo "------------------------------------------------------------------------------">>$logfile
echo "Inizio Pruning "`date`>>$logfile
echo "------------------------------------------------------------------------------">>$logfile
# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --verbose                       \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \
    $REPOSITORY                     \
2>&1                                \
| tee -a $logfile

prune_exit=${PIPESTATUS[0]}

echo "------------------------------------------------------------------------------">>$logfile
echo "Inizio List "`date`>>$logfile
echo "------------------------------------------------------------------------------">>$logfile
borg list $REPOSITORY 		   \
2>&1                           \
| tee -a $logfile

echo "------------------------------------------------------------------------------">>$logfile
echo "File modificati "`date`>>$logfile
echo "------------------------------------------------------------------------------">>$logfile

cat tmp_file >> $logfile
rm tmp_file
echo "------------------------------------------------------------------------------">>$logfile
echo "Fine "`date`>>$logfile
echo "------------------------------------------------------------------------------">>$logfile


# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 1 ];
then
    echo "Backup and/or Prune finished with a warning" | tee -a $logfile
fi

if [ ${global_exit} -gt 1 ];
then
    echo "Backup and/or Prune finished with an error" | tee -a $logfile
fi


# Unset the password
#export BORG_PASSPHRASE=""
gzip $logfile
read -n1 -r -p "Press any key to continue..." key
exit ${global_exit}
