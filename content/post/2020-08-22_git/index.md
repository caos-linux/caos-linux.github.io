---
title: "Guida quick & dirty a Git"
date: 2020-08-22
draft: false
tags: [git]
summary: Alcuni comandi basilari su git
type: post
showTableOfContents: true
---

## Guide in rete:

* https://git-scm.com/ Official git site and tutorial cap 2 book
* https://guides.github.com GitHub guides
* https://education.github.com/git-cheat-sheet-education.pdf Commands
cheatsheet
* https://try.github.io/levels/1/challenges/1 Interactive git tutorial
* http://ndpsoftware.com/git-cheatsheet.html Visual/interactive
cheatsheet

## Comandi locali


```bash
git init
git add .
git status  # vedo lo stato dei file
git diff    # modifiche da buttare nello stage
git commit -m "descrizione commmit"
git log -p  # modifiche dei vari commit
```

Per restorare un file modificato ma non messo in stage:

- vedere comando dato da git status

Per restorare un file modificato aggiunto in stage:

- vedere comando dato da git status


Per vedere l'elenco dei commit:

```bash
git log --pretty=oneline

843e53fb8f16a1705a466d3738f232767592062d (HEAD -> master) quarto
a4ad24ab44f13165e480657c2af797c42fb3bb49 terzo
f2c0d9d8f589d7c64d34edbb6aea38f20dd75257 secondo
656500c009d78ab6015739f69fabd76ba943c6a0 primo
```

Per tornare ad vecchio commit:

```bash
git checkout 656500c009d78ab6015739f69fabd76ba943c6a0
```

Per tornare all'ultimo commit:

```bash
git switch -
```

Per vedere i file modificati dall'ultimo commit:
```bash
git diff
```


## Per caricare su github

* creare repo su github
* non creare README
* dalla cartella locale:

```bash
git remote add origin https://github.com/utente/test-git.git
git push -u origin master
```

* andare avanti con:
```bash
modifica file
git add .
git commit -m "descr"
git push -u origin master
```

## Per scaricare aggiornamenti remoti

```bash
git fetch origin
```

poi
```bash
git merge
```

oppure tutto insieme
```bash
git pull
```
