---
title: "Generatore di sequenza di interi pseudo-random"
date: 2020-06-13
draft: false
tags: [random]
summary: Generatore di sequenza di interi pseudo-random, compresa tra un valore minimo ed un valore massimo, basata su generatore Mersenne-twister scritto in javascript
type: post
showTableOfContents: true
---


Generatore di sequenza di interi pseudo-random, compresa tra un valore minimo ed un valore massimo, basata su generatore Mersenne-twister scritto in javascript <https://gist.github.com/banksean/300494>.

A parità di seme, la sequenza generata è sempre la stessa.

{{< rawhtml >}}
<form id="frm1">

  <p>Valore minimo <input type="text" name="min" value="10" size="6" maxlength="12"> </p>

  <p>Valore massimo <input type="text" name="max" value="25" size="6" maxlength="12"> </p>

<p> Seme  <input type="text" id="id" size="16" maxlength="64" value="123"> </p>

</form>

<button onclick="myFunction()">Estrazione</button>


<p id="demo"></p>

<script type="text/javascript" src="mersenne-twister.js"></script>

<script type="text/javascript">

var bucket = [];
var estr =[];


function getRandomFromBucket(rnd) {
//   var randomIndex = Math.floor(Math.random()*bucket.length);
   var randomIndex = Math.floor(rnd*bucket.length);
   return bucket.splice(randomIndex, 1)[0];
}

function myFunction() {
  var x = document.getElementById("frm1");
  var text = "";
  var i;


  min=parseInt(x.elements[0].value);
  max=parseInt(x.elements[1].value);
  seed=parseInt(x.elements[2].value);

  var m = new MersenneTwister(seed);
  bucket = [];
  estr =[];

  for (var i=min;i<=max;i++) {
    bucket.push(i);
   }

/*
  text += "min = " + min + "<br>";
  text += "max = " + max + "<br>";
  text += "seed = " + seed + "<br>";
  text += "bucket = " + bucket + "<br>";
*/

  for (var i=min;i<=max;i++) {
  estr.push(getRandomFromBucket(m.random()));
   }
//  text += "estr = " + estr + "<br>";


  text += "<table>";
  text += "<tr><th> Posizione </th><th>Estratto </th></tr>";
  for (var i = 0; i < estr.length; i++) {
    var p=i+1;
    text +=  "<tr><td>" + p + "</td><td>" + estr[i] + "</td></tr>";
  }
  text += "</table>"

  document.getElementById("demo").innerHTML = text;
}



//console.log(getRandomFromBucket());




</script>

{{< /rawhtml >}}



Progetto su Github:

<https://github.com/caos-linux/Mersenne-Twister-Random-Sequence-Generator>
