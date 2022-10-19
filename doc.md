# DPLL Algorithm
>**Deadline**: 27/10/2022   
>**Last Update**: 14/10/2022   
>**Project Phase**: P1 - LO5 Lectures review.

- [DPLL Algorithm](#dpll-algorithm)
  - [Objective](#objective)
  - [Deliverables](#deliverables)
  - [Backlog](#backlog)
  - [Timeline](#timeline)
  - [Methods to implement](#methods-to-implement)
    - [simplifie()](#simplifie)
    - [unitaire()](#unitaire)
    - [pur()](#pur)
    - [solveur_dpll_rec()](#solveur_dpll_rec)
  - [Testing code](#testing-code)
  - [Resources](#resources)

## Objective 
Le but du mini-projet est d'implémenter un solveur DPLL récursif en OCaml. Vous devez compléter pour cela le code dans le fichier dpll.ml

Pour plus d'informations, voir [MP1 Solveur DPLL récursif](https://moodle.u-paris.fr/mod/assign/view.php?id=366100)

## Deliverables
Fichiers à rendre: 
1. `Rendu`
2. `dimacs.ml`
3. `dpll.ml`
4. `Makefile`

## Backlog
- [x] Lectures review (focus on week 10/10)
- [x] Code Analysis
- [x] OCaml environment ([Running OCaml](https://gaufre.informatique.univ-paris-diderot.fr/letouzey/pf5/blob/master/slides/cours-03-outils.md))
- [x] Dev plan
- [ ] Simplifie()
- [ ] Unitatire()
- [ ] Pur()
- [ ] DPLL()

## Timeline
![Timeline](/res/timeline.png)

## Methods to implement

### simplifie()
La simplification revient effectivement à substituer ⊤ à l et ⊥ à (-l) dans toutes les clauses de S et à
simplifier le résultat en utilisant les équivalences logiques φ∨⊤ ⇔ ⊤, φ∨⊥ ⇔ φ et φ∧⊤ ⇔ φ.
La simplification d’un ensemble F de clauses par un littéral 'l' s’écrit en pseudo-code comme suit.

```python
fonction simplifie(F, l): #F est une formule prop et 'l' le literaux à simplifier.
  newF = emptyList()
  pour toutes les C dans F faire: # Loop dans chaque clause de F.
    si l not in C alors:
      newF.append(C\{-l}) #on va ajouter le clause sans ajouter le negative de l, s'il existe.
  return newF
```

Pour plus d'information voir les examples de simplification avec Java dans le [poly du cours](https://www.irif.fr/~schmitz/teach/2022_lo5/notes.pdf).


---

### unitaire()

```java
Optional<Clause> unitaire = clauses.stream().filter(c -> c.size() == 1).findAny();
if (unitaire.isPresent()) {
  int l = unitaire.get().stream().findAny().get().intValue();
  return simplifie(l).satisfiable();
}
```
---

### pur()


```java
for (int i = 0; i < nprops; i++)
  if (interpretation[i] == 0) {
    final Integer l = Integer.valueOf(i+1);
    final Integer notl = Integer.value(-i-1);
    if (clauses.stream().noneMatch(c ->c.stream().anyMatch(j -> j.equals(notl))))
      return simplifie(l.intValue()).satisfiable();
    if (clauses.stream().noneMatch(c ->c.stream().anyMatch(j -> j.equals(l))))
      return simplifie(notl.intValue()).satisfiable();
```

---

### solveur_dpll_rec()

1. Ensemble vide de clauses est satisfiable
2. Une clause vide est instatisfiable
3. Clause unitaire
4. Literal pur
5. Branchement 


---

## Testing code
*todo*
## Resources
* [OCaml Overview](https://ocaml.org/docs/first-hour)
* [OCaml exercices](https://ocaml.org/problems)
