# Rapport — Jeu de la Vie, exécution concrète et symbolique

## Introduction

Ce projet consiste a pour but l’interpréteur Wasm fourni afin d’ajouter :

- un moteur concret capable d’exécuter un Jeu de la Vie,
- ajout de fonctions primitives externes,
- une partie graphique avec la bibliothèque Raylib,
- des options de contrôle de l’exécution,
- ainsi qu’un moteur d’exécution symbolique permettant de résoudre des contraintes.

L’objectif était également d’utiliser l’exécution symbolique dans une approche de *Solver-Aided Programming* afin de générer automatiquement des configurations satisfaisant certaines propriétés.

# Partie concrète

## Ajout de primitives externes

Plusieurs primitives ont été ajoutées au module externe `ono` afin d’étendre les capacités des programmes Wasm exécutés en mode concret.

### Affichage

Ajout de :

- print_i32
- print_i64

Ces fonctions permettent l’affichage de valeurs entières WebAssembly depuis les programmes Wasm.

### Génération aléatoire

Ajout de :

- random_i32
- random_i32_under

Ces fonctions permettent de générer des valeurs pseudo-aléatoires afin d’initialiser des grilles du Jeu de la Vie.

Une option --seed a également été ajoutée afin de rendre les tests possibles.

Exemple :

```bash
dune exec ono -- concrete --seed 42 test/cram/concrete/game.t/game.wat
```

### Lecture depuis l’entrée standard

Ajout de :

- read_i32

Cette primitive permet de lire un entier depuis l’entrée standard.

Elle est notamment utilisée dans la partie symbolique pour lire les coefficients du solveur de polynômes entrée par l'utilisateur.

### Contrôle de l’exécution

Ajout de :
- should_continue
- should_display
- next_step

Ces primitives permettent de contrôler l’exécution du Jeu de la Vie directement depuis le programme Wasm.

Elles ont été utilisées pour implémenter les nouvelles options de ligne de commande :

- --steps N : Afficher les N premieres générations.
- --display-last N : Afficher les N dernieres générations.

# Jeu de la Vie

## Représentation

La grille du Jeu de la Vie est stockée dans la mémoire linéaire WebAssembly.

Chaque cellule est représentée par :

- 0 : cellule morte,
- 1 : cellule vivante.

Le programme Wasm calcule les générations successives en appliquant les règles classiques du Jeu de la Vie de Conway.

## Règles d’évolution

Les règles implémentées sont les suivantes :

- une cellule vivante survit avec 2 ou 3 voisins,
- une cellule morte devient vivante avec exactement 3 voisins,
- dans tous les autres cas, la cellule est morte.


## Démonstration : planeur

Une configuration de type *planeur* a été ajoutée afin de vérifier visuellement le comportement du moteur.

Le déplacement du planeur permet de confirmer :

- la bonne mise à jour des cellules,
- la bonne gestion des voisinages,
- le bon affichage des générations.

# Interface graphique

## Utilisation de Raylib

Un mode graphique a été ajouté grâce à la bibliothèque Raylib.

L’objectif était de conserver exactement le même programme Wasm tout en changeant uniquement l’implémentation des primitives externes côté OCaml.

Le programme Wasm utilise uniquement :

- print_cell
- newline
- clear_screen

Ces primitives sont ensuite interprétées différemment selon le mode choisi.

## Mode texte et mode graphique

Deux interprétations du module externe existent désormais :

- une version terminal,
- une version graphique.

Le choix s’effectue avec :

```bash
dune exec ono -- concrete --use-graphical-window file.wat
```

## Affichage de la grille

La grille est d’abord reconstruite côté OCaml à partir des appels successifs à :

- print_cell
- newline

Puis elle est affichée via Raylib.

Chaque cellule est représentée par un rectangle :

- gris clair : cellule morte,
- gris foncé : cellule vivante.

# Options ajoutées au Jeu de la Vie

## Option --steps N

Cette option permet de limiter le nombre de générations exécutées.

Exemple :

```bash
dune exec ono -- concrete --steps 5 test/cram/concrete/game.t/game.wat
```

Le programme s’arrête alors après 5 itérations.

Cette fonctionnalité est implémentée grâce à :

- un compteur de générations,
- la primitive `should_continue`.

## Option --display-last N

Cette option permet de n’afficher que les dernières générations.

Exemple :

```bash
dune exec ono -- concrete --steps 5 --display-last 2 test/cram/concrete/game.t/game.wat
```

Ici :

- 5 générations sont calculées,
- seules les 2 dernières sont affichées.

Cette fonctionnalité repose sur la primitive should_display.

Inconvénient : La génération des N premières générations à l'aide de steps prend un peu de temps. Cela met donc un peu de temps avant d'afficher
le résultat de display-last. Une optimisation est surment possible.

# Exécution symbolique

## Principe

Le moteur d’exécution symbolique permet d’exécuter un programme avec des valeurs inconnues appelées symboles.

Au lieu d’exécuter le programme avec des valeurs concrètes, le moteur :

- construit des contraintes,
- explore les branches du programme,
- utilise un solveur SMT,
- produit un modèle satisfaisant les contraintes.

Dans ce projet, l’idée de *Solver-Aided Programming* a été utilisée :

- une solution recherchée est transformée en *unreachable*
- le moteur considère alors cette situation comme un bug,
- le modèle retourné correspond à une solution du problème.

# Génération symbolique de configurations du Jeu de la Vie

## Principe

Des grilles symboliques 3x3 ont été générées.

Chaque cellule est une variable symbolique contrainte à :

- 0 : morte,
- 1 : vivante.

Le programme calcule ensuite une ou plusieurs générations du Jeu de la Vie.

Lorsqu’une propriété souhaitée est satisfaite, le programme déclenche volontairement :

```wat
unreachable
```

Le solveur SMT produit alors une configuration initiale satisfaisant la propriété.

## Contraintes implémentées

Les contraintes suivantes ont été réalisées.

### Centre vivant au tour suivant

Le solveur génère une configuration telle que la cellule centrale soit vivante après une génération.

### Naissance du centre

Le solveur génère une configuration telle qu’une cellule centrale initialement morte naisse au tour suivant.

### Ligne centrale vivante

Le solveur génère une configuration telle que toute la ligne du milieu soit vivante après une génération.

### Oscillateur de période 2

Le solveur génère une configuration qui revient à son état initial après deux générations.

Cette contrainte est plus coûteuse car elle nécessite le calcul de deux étapes complètes du Jeu de la Vie.

# Solveur de polynômes

## Objectif

Un solveur de polynômes de degré inférieur ou égal à 3 a été implémenté à l’aide de l’exécution symbolique.

Le programme Wasm lit les coefficients devant être entrée par l'utilisateur un par un :

- `a`
- `b`
- `c`
- `d`

puis recherche des racines entières satisfaisant :

```text
P(x) = ax^3 + bx^2 + cx + d = 0
```

## Utilisation du moteur symbolique

Les racines candidates sont créées avec :

```wat
i32_symbol
```

Lorsqu’une racine valide est trouvée, le programme déclenche volontairement :

```wat
unreachable
```

Le solveur SMT produit alors un modèle contenant les solutions.

---

## Gestion des degrés

Le solveur distingue automatiquement :

- degré 3,
- degré 2,
- degré 1.

Des fonctions séparées ont été implémentées :

- solve_degree_3
- solve_degree_2
- solve_degree_1

## Racines multiples

Le solveur gère également les racines doubles pour les polynômes de degré 2.

Exemple :

```text
x^2 - 2x + 1
```

Le solveur retourne correctement :

```text
1
```

une seule fois.

---

# Tests

## Tests cram

Des tests cram ont été ajoutés pour :

- le Jeu de la Vie,
- les options --steps et --display-last`,
- le solveur de polynômes,
- les contraintes symboliques.

# Limites

## Écriture directe en WAT

L’écriture manuelle de programmes WAT devient rapidement très verbeuse.

Même des programmes relativement simples nécessitent un grand nombre d’instructions explicites.

## Explosion combinatoire

L’exécution symbolique devient rapidement coûteuse lorsque :

- la taille des grilles augmente,
- plusieurs générations doivent être calculées,
- les contraintes deviennent globales.

Le cas de l’oscillateur de période 2 est déjà significativement plus complexe qu’une simple contrainte locale.

---

## Arithmétique modulo 2^32

Les entiers WebAssembly sont représentés en `i32`, donc les calculs sont effectués modulo `2^32`.

Cela peut produire des solutions artificielles lors de la résolution symbolique des polynômes.

Des bornes ont été ajoutées afin de limiter ce phénomène.

# Commandes utiles

## Compilation

```bash
dune build
```

## Lancer tous les tests

```bash
dune runtest
```

## Tests du Jeu de la Vie concret

```bash
dune runtest test/cram/concrete/game.t
```

## Tester `--steps`

```bash
dune exec ono -- concrete --steps 5 test/cram/concrete/game.t/game.wat
```

## Tester `--display-last`

```bash
dune exec ono -- concrete --steps 5 --display-last 2 test/cram/concrete/game.t/game.wat
```

Ajouter `--seed 42` permet d’obtenir une exécution déterministe.



```bash
dune exec ono -- concrete --steps 5 --display-last 2 --seed  test/cram/concrete/game.t/game.wat
```

## Tests cram des nouvelles options

```bash
dune runtest test/cram/concrete/game_steps.t
```

```bash
dune runtest test/cram/concrete/game_display_last.t
```

## Jeu de la Vie en mode texte

```bash
timeout 10s dune exec -- ono concrete test/cram/concrete/game.t/game.wat
```

## Jeu de la Vie en mode graphique

```bash
timeout 10s dune exec -- ono concrete --use-graphical-window test/cram/concrete/game.t/game.wat
```

## Démonstration du planeur

```bash
timeout 15s dune exec -- ono concrete --use-graphical-window test/cram/concrete/game.t/game_glider.wat
```

## Génération symbolique de configurations

Centre vivant au tour suivant :

```bash
dune exec -- ono symbolic test/cram/symbolic/life_config.t/center_alive_next.wat
```

Naissance du centre :

```bash
dune exec -- ono symbolic test/cram/symbolic/life_config.t/center_birth_next.wat
```

Ligne centrale vivante :

```bash
dune exec -- ono symbolic test/cram/symbolic/life_config.t/row_middle_alive_next.wat
```

Oscillateur de période 2 :

```bash
dune exec -- ono symbolic test/cram/symbolic/life_config.t/oscillator_period_2.wat
```

Ces programmes déclenchent volontairement `unreachable` lorsque la contrainte est satisfaite.

Le modèle affiché par le solveur correspond alors à une configuration initiale valide.

---

## Solveur de polynômes

Exécution interactive :

```bash
dune exec ono -- symbolic test/cram/symbolic/polynomial.t/polynomial.wat
```

L’utilisateur saisit ensuite les coefficients :

```text
1
-7
14
-8
```

Le solveur retourne alors les racines du polynôme.

---

## Affichage graphique sous WSL

Sous WSL, il peut être nécessaire d’utiliser :

```bash
unset LIBGL_ALWAYS_INDIRECT
export LIBGL_ALWAYS_SOFTWARE=1
```

avant de lancer Raylib.

## Docummentation ODOC

```bash
dune build @doc
```
L'index.html se trouve dans ono-ryff\_build\default\_doc\_html\index.html


