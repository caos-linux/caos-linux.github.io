---
title: "Random Graphics"
date: 2023-09-05T16:10:59+02:00
draft: false
tags: [random]
type: post
showTableOfContents: true
---

## Introduzione
Questa app mette in evidenza la correlazione che si può manifestare nei generatori di numeri random, in particolare se il generatore è di tipo lineare congruenziale.

<!--more-->


Il programma [pagina github](https://github.com/caos-linux/random-graphics) genera numeri casuali appartenenti all'intervallo [0,1[. I numeri ottenuti vengono presi a coppie e rappresentati in un riferimento cartesiano x,y.

Per ottenere istanze di numeri casuali si può scegliere una della routine standard ran1, ran2 o ran3 (Numerical Recipes in C - second edition), il generatore Mersenne Twister, oppure si può definire da input i coefficienti di un generatore lineare congruenziale. Si ricorda che il significato dei coefficienti è il seguente:

Z<sub>i+1</sub></span>=(a*Z<sub>i</sub> +c) mod m


Per ottenere numeri appartenenti a [0,1[ si dividono le Z<sub>i</sub> per il termine m.

## App
Select a Random numbers generator:

{{< rawhtml >}}

  <script src='https://cdn.plot.ly/plotly-2.25.2.min.js'></script>
  <script type="text/javascript" src="ran123.js"></script>
  <script type="text/javascript" src="mersenne-twister.js"></script>

<select id="select1">
    <option value="ranLC">ranLC</option>
    <option value="ran1">ran1</option>
    <option value="ran2">ran2</option>
    <option value="ran3">ran3</option>
    <option value="ranMT">ranMT</option>
  </select>


  <form id="frm1">
    Seed  <input type="text" id="id" size="16" maxlength="64" value="-123"> <br>
    a  <input type="text" id="id" size="16" maxlength="64" value="16807"> <br>
    c  <input type="text" id="id" size="16" maxlength="64" value="0"> <br>
    m  <input type="text" id="id" size="16" maxlength="64" value="2147483647"> <br>
    No. of points  <input type="text" id="id" size="16" maxlength="64" value="100"> <br>
  </form>

   <button onclick="myFunction()">Draw</button>
  <div id='myDiv' style="width:100%;text-align: center;">
    <!-- Plotly chart will be drawn inside this DIV -->
  </div>
 
<script type="text/javascript">
    
function myFunction() {
    var f = document.getElementById("frm1");
    seed=parseInt(f.elements[0].value);
    a=parseInt(f.elements[1].value);
    c=parseInt(f.elements[2].value);
    m=parseInt(f.elements[3].value);
    n=parseInt(f.elements[4].value);


    selectElement = document.querySelector('#select1');
    output = selectElement.value;
//    document.querySelector('.output').textContent = output;

    switch(output) {
    case "ranLC":
	var m = new RandLC(seed,a,c,m);
	break;
    case "ran1":
	var m = new Rand1(seed);
	break;
    case "ran2":
	var m = new Rand2(seed);
	break;
    case "ran3":
	var m = new Rand3(seed);
	break;
    case "ranMT":
	var m = new MersenneTwister(seed);
	break;
    }
    
    x =[];
    y=[];
    var i;

        var trace1 = {
	x: [],
	y: [],
	mode: 'markers'
    };

    for (var i=1;i<=n;i++) {
	x.push(m.random());
	y.push(m.random());
    } 

    var trace1 = {
	x: x,
	y: y,
	mode: 'markers'
    };

    var data = [ trace1 ];

    var layout = {
	title:'Scatter Plot'
    };

    Plotly.newPlot('myDiv', data, layout);
}
</script>

{{< /rawhtml >}}

## Note

Per utilizzare le routines ran1, ran2, ran3 è necessario impostare un valore di seed negativo: questo serve per permettere la corretta inizializzazione del generatore, dopo della quale seed viene invertito di segno.
Per quanto riguarda la definizione dei parametri del generatore lineare congruenziale si suggeriscono i seguenti esempi:

### Esempio 1
seed=1;\
a=3;\
c=5;\
m=1024;

![es1](es1.avif "es1")

Il primo esempio mette in evidenza il problema della correlazione che si può manifestare nei generatori di numeri casuali lineari congruenziali. Ovviamente si tratta di un caso estremo.

### Esempio 2
seed=1;\
a=16807;\
c=0;\
m=2147483647;

![es2](es2.avif "es2")

Questo esempio è stato proposto da Park e Miller come standard minimo di qualità per un generatore di numeri casuali.


