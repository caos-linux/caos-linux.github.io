---
title: "Guida quick & dirty su ffmpeg"
date: 2022-07-19T16:03:45+02:00
draft: false

categories: []
tags: [ffmpeg]
summary: Appunti su ffmpeg
ShowToc: true
type: post
showTableOfContents: true
---

### Installazione (Windows)

- Scaricare da: https://ffmpeg.org/download.html#build-windows
- scomprimere in c:\ffmpeg
- pannello di controllo - sistema - variabili di ambiente - variabili per l'utente - modificare %PATH% aggiungendo a quanto già scritto "c:\ffmpeg\bin"

### Per vedere le tracce di un file

```bash
ffmpeg -i file.mp4 


Stream #0:0(eng): Video: h264 (High), yuv420p, 1280x528 [SAR 99:100 DAR 12:5 SAR 211:213 DAR 16880:7029, 23.98 fps, 23.98 tbr, 1k tbn, 47.95 tbc (default)
Stream #0:1(eng): Audio: ac3, 48000 Hz, 5.1(side), fltp, 640 kb/s
Stream #0:2(ita): Audio: ac3, 48000 Hz, 5.1(side), fltp, 448 kb/s (default)
Stream #0:3(ita): Subtitle: subrip (default)
```
### Cambiare audio ad un video con un altro audio

```bash
ffmpeg -i video.asf -i audio.mp3 -map 0:0 -map 1:0 -c copy output.avi
```

### Estrarre da un film video e il solo audio italiano

```bash
ffmpeg -i file.mp4 -map 0:0 -map 0:2 -c copy new_file.mp4
```

### Join Video file

Assuming the codecs are the same you create a file (example list.txt):
```
file '/path/here/file1.avi'
file '/path/here/file2.avi'
file '/path/here/file3.avi'
```
Then pass that file to ffmpeg
```bash
ffmpeg -f concat -i list.txt -c copy video_draft.avi
```
rif.: http://stackoverflow.com/questions/15186500/howto-merge-two-avi-files-using-ffmpeg

oppure:
```cmd
Copy /b *.dv video.dv
```

### Encode in DivX

```
ffmpeg -i "filmato.MOV" -c:v mpeg4 -vtag xvid -qscale:v 3 -c:a libmp3lame -qscale:a 4 output.avi
```

rif.: https://trac.ffmpeg.org/wiki/How%20to%20encode%20Xvid%20/%20DivX%20video%20with%20ffmpeg

### Combinare video di un film e audio di un altro:

```
ffmpeg –i video_con_video_buono.mkv -i video_con_audio_buono.avi -map 0:0 -map 1:1 -c copy video_perfetto.mkv
```

### Cambio container file avi

```
ffmpeg -fflags +genpts -i "video.avi" –c copy video.mkv
```

### Cambiare tempo a audio da NTSC a PAL

http://forum.divxmania.it/sincronizzare-audio-e-video-in-un-mkv/t12557/p/20.html

ho estratto l’italiano dal file PAL a 25 fps, in mp3 e con audacity Effetti-> Cambia tempo: +4.096%

Altro film
```
ffmpeg -i "video.avi" -map 0:1 -c copy ita.mp3
```
con audacity Effetti-> Cambia tempo: -4.096%

### Estrarre un pezzetto di filmato
```
ffmpeg -i 20140807_20-35-46.asf \
-c copy -ss 00:04:18 -to 01:42:00 clip.asf
```
estrae dal 4 min e 18 fino a 1h 42min e copia su nuovo file
```
ffmpeg -i file.mp4 -c copy -ss 00:04:18 clip.mp4
```
estrae dal 4 min e 18 in poi.

### Estrarre 2 pezzetti di filmato

Ripetere 2 volte il processo precedente e concatenare
```bash
$ ffmpeg -ss 60 -i input -t 5 -codec copy clip1.mkv
$ ffmpeg -ss 120 -i input -t 5 -codec copy clip2.mkv
$ echo "file 'clip1.mkv'" > concat.txt
$ echo "file 'clip2.mkv'" >> concat.txt
$ ffmpeg -f concat -i concat.txt -codec copy output.mkv
```

### Convertire MOV fotocamera a AVI

```
ffmpeg -i input.flv -b 2048k output.avi
```

### Embeddare subtitles (burn) in un video

http://www.epinionated.net/handbrake-burn-in-subtitles-mkv-mp4-apple-tv/

### Ruotare video lossless

```
ffmpeg -i input.mp4 -c copy -metadata:s:v:0 rotate=90 output.mp4
```

https://stackoverflow.com/questions/15335073/can-i-set-rotation-field-for-a-video-stream-with-ffmpeg/15336581#15336581

```bash
ffmpeg -i in.mp4 -metadata:s:v rotate=0 -codec copy put.mp4
```
0 resetta la impostazione fatte dal cellulare



### Rotating videos with FFmpeg

```
ffmpeg -i "video_storto.mp4" -vf "transpose=1" -c:v libx264 -preset slow -crf 18 -c:a copy "video_dritto.mkv"
```
For the transpose parameter you can pass:

0 = 90CounterCLockwise and Vertical Flip (default)
1 = 90Clockwise
2 = 90CounterClockwise
3 = 90Clockwise and Vertical Flip

### Split AVI
```
ffmpeg -i video-giusto-divx.avi -ss 00:00:00 -t 00:23:58 -c copy caselle_93_1.avi
```
http://www.compmiscellanea.com/en/split-video-file-ffmpeg.htm


### Ridimensionamento video
```
for file in *.MTS; do ffmpeg -i "$file" -vf scale=1280:-1 "small-$file";done
```

### Conversione in MP3
```
for file in *.flac; do ffmpeg -i "$file" -codec:a libmp3lame -qscale:a 0 "$file.mp3";done
```
### Conversione in OPUS
```
ffmpeg -i input -acodec libopus -b:a bitrate -vbr on -compression_level 10 output
```
http://ffmpeg.org/ffmpeg-codecs.html#libopus-1

### Merge foto + audio

(usato il 15.3.19)
```
ffmpeg -loop 1 -i vlcsnap-2019-03-15-12h03m02s461.png \
-i seconda_parte.mp3 -c:v libx264 -tune stillimage \
-c:a aac -b:a 192k -pix_fmt yuv420p -shortest seconda_parte.mp4
```
https://superuser.com/questions/1041816/combine-one-image-one-audio-file-to-make-one-video-using-ffmpeg

### Extract thumbnail

```
ffmpeg -i video.mp4 -map 0:v -map -0:V -c copy cover.jpg
```
