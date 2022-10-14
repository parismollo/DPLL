                Mini-projet 1 : solveur DPLL récursif


Objectif du mini-projet
-----------------------

Le but du mini-projet est d'implémenter un solveur DPLL récursif en
OCaml. Vous devez compléter pour cela le code dans le fichier dpll.ml :

 - la fonction simplifie : int -> int list list -> int list list
 - la fonction unitaire : int list list -> int
 - la fonction pur : int list list -> int
 - la fonction solveur_dpll_rec : int list list -> int list -> int list option

Ces types et les commentaires dans dpll.ml sont indicatifs. D'autres
choix peuvent être pertinents; par exemple, unitaire et pur
pourraient aussi être de type int list list -> int option. Aussi, les
définitions `let foo ...' peuvent être transformées en `let rec foo ...' ou
inversement.

Documentation 
-------------

Une attention particulière sera portée sur la documentation de votre
code : la pertinence et la clarté de cette dernière comptera pour un
pourcentage important de votre note finale. Vous devrez donc soigner
les explications qui accompagneront votre code et ce sur deux volets
principaux :

1. Le fichier RENDU contient des questions précises sur votre
   implémentation. Vous êtes requis d'y répondre en complétant le même
   fichier, qui devra faire partie de votre rendu final. Vos réponses
   doivent être claires, précises et préférablement succinctes. À la
   lecture de vos réponses, une compréhension globale, sans ambiguïté,
   de votre implémentation devra facilement se dégager.

   Un mini-projet sans fichier RENDU rempli ne recevra pas de note.

2. Vous devez impérativement commenter votre code dans le but de
   complémenter les explications fournies lors du remplissage du
   fichier RENDU (volet 1 ci-dessus). Dans le même esprit, vos
   commentaires doivent être clairs et précis, ils doivent donner une
   compréhension plus fine des détails de votre implémentation.

   Un code non commenté entraînera automatiquement une note finale
   lourdement pénalisée.

Code correct vs. code optimisé
------------------------------

Assurez-vous que votre code compile avant de le rendre.

En outre, vous devez prioriser vos objectifs d'une manière saine : un
code correct et lent est meilleur qu'un code erroné et
rapide. Résolvez le problème, puis optimiser votre code (do it right,
then do it better). Une implémentation optimisée n'aura un impact
positif sur votre note finale que si elle est correcte.

Tester son mini-projet
----------------------

Outre les exemples de test inclus dans dpll.ml (exemple_3_12,
exemple_7_2, exemple_7_4, exemple_7_8, systeme, coloriage), vous
pouvez utiliser le Makefile en appelant

  make

pour compiler un exécutable natif et le tester sur des fichiers au
format DIMACS. Vous trouverez des exemples de fichiers à l'adresse

  https://www.irif.fr/~schmitz/teach/2022_lo5/dimacs/

Par exemple,

  ./dpll chemin/vers/sudoku-4x4.cnf

devrait répondre

SAT
-111 -112 113 -114 -121 -122 -123 124 -131 132 -133 -134 141 -142 -143 -144 -211 212 -213 -214 221 -222 -223 -224 -231 -232 -233 234 -241 -242 243 -244 311 -312 -313 -314 -321 322 -323 -324 -331 -332 333 -334 -341 -342 -343 344 -411 -412 -413 414 -421 -422 423 -424 431 -432 -433 -434 -441 442 -443 -444 0

Si vous faites des affichages pour vos propres tests, il faudra penser
à commenter ces tests pour que votre programme réponde exactement
comme indiqué juste ci-dessus. 


Rendre son mini-projet
----------------------

 - date limite : 28 octobre 2022, 23h59
 - sur la page Moodle du cours
     https://moodle.u-paris.fr/course/view.php?id=1657
 - sous la forme d'une archive XX-nom1-nom2.zip où `XX' est le numéro
   de binôme déclaré à la page
     https://moodle.u-paris.fr/mod/choicegroup/view.php?id=82687
   et `nom1' et `nom2' sont les noms de famille des deux membres du
   binôme, contenant l'arborescence suivante :
     XX-nom1-nom2/dpll.ml
     XX-nom1-nom2/dimacs.ml
     XX-nom1-nom2/Makefile
     XX-nom1-nom2/RENDU
