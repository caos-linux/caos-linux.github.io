---
title: "Backup con Borg Backup"
date: 2017-12-30
draft: false
tags: [backup, linux]
summary: Procedura per il backup dati di un sistema linux su un HD portatile, grazie al programma borg backup.
type: post
showTableOfContents: true
---

Vogliamo eseguire il backup dei dati utente di un sistema linux su un HD portatile.

Utilizziamo il tool linux da linea di comando borgbackup (<https://github.com/borgbackup/borg>).

## Installazione

* scaricare binario da https://github.com/borgbackup/borg/releases
* rename in borg e chmod +x
* spostare in ~/bin

## Preparazione HD portatile
* formattare in ext4
* creare file gigante per non incorrere in problemi di spazio su disco:

```bash
fallocate -l 2G spaziolibero.out
```
* creare repository denominato "borg":


```bash
borg init --encryption=repokey borg
```

e mettere la password 2 volte

## Script su HD portatile `backup.sh`
Il seguente script:

* chiede la password da input
* esegue il salvataggio delle cartelle selezionate ma non di quelle escluse
* cancella i vecchi backup secondo la politica di pruning impostata
* riporta a video e in un file i log delle operazioni

```bash 
{{% include "backup.sh" %}}
```

## Script su HD portatile `borgmount.sh`
Il secondo script:

* chiede la password da input
* monta il backup (se non è già montato)
* smonta il backup (se è già montato)

```bash
{{% include "borgmount.sh" %}}

```
## Utilizzo
Backup:

* collegare l'hard disk al PC e lanciare il comando `backup.sh`.

Restore:

* collegare l'hard disk al PC e lanciare il comando `borgmount.sh` per montare i backup.
* navigare nelle cartelle montate e accedere ai file salvati
* lanciare il comando `borgmount.sh` per smontare i backup.
* scollegare l'hard disk
