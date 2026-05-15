# Rapport

## Partie concrète

- Ajout des préliminaires concrets.
- Ajout de `print_i64`.
- Ajout de `random_i32` avec option `--seed` pour rendre les tests déterministes.
- Correction de la règle de mise à jour du jeu de la vie.

## Jeu de la vie

- La grille est stockée dans la mémoire linéaire Wasm.
- Les cellules sont mises à jour selon les règles classiques :
  - une cellule vivante survit avec 2 ou 3 voisins
  - une cellule morte naît avec exactement 3 voisins.
- Ajout d’une démo planeur pour vérifier visuellement le comportement.

## Interface graphique

- Ajout d’un mode graphique avec Raylib.
- Ajout de l’option `--use-graphical-window`.
- Le programme Wasm reste le même : il appelle `print_cell`, `newline` et `clear_screen`.
- Côté OCaml, ces primitives sont réinterprétées pour dessiner la grille dans une fenêtre.

## Génération symbolique

- Création de grilles 3x3 avec des cellules symboliques.
- Chaque cellule est contrainte à valoir 0 ou 1.
- Les contraintes sont transformées en `unreachable` volontaire pour obtenir un modèle avec `ono symbolic`.

Contraintes réalisées :
- centre vivant au tour suivant
- centre mort qui naît au tour suivant
- ligne du milieu vivante au tour suivant
- oscillateur de période 2

## Limites

- L’écriture directe en WAT devient vite longue.
- L’oscillateur de période 2 demande déjà de calculer deux étapes complètes.
- Une grille plus grande ou des contraintes plus globales augmenteraient fortement la taille des formules symboliques.

## Commandes utiles

### Compilation

```bash
dune build
```

### Lancer tous les tests

```bash
dune runtest
```

### Lancer les tests du jeu de la vie concret

```bash
dune runtest test/cram/concrete/game.t
```

### Lancer les tests de génération symbolique

```bash
dune runtest test/cram/symbolic/life_config.t
```

### Exécuter le jeu de la vie en mode texte

Le programme boucle volontairement, donc on utilise `timeout` pour l’arrêter après quelques secondes.

```bash
timeout 10s dune exec -- ono concrete test/cram/concrete/game.t/game.wat
```

### Exécuter le jeu de la vie en mode graphique

```bash
timeout 10s dune exec -- ono concrete --use-graphical-window test/cram/concrete/game.t/game.wat
```

### Exécuter la démo du planeur en mode graphique

```bash
timeout 15s dune exec -- ono concrete --use-graphical-window test/cram/concrete/game.t/game_glider.wat
```

### Exécuter les générations symboliques

Centre vivant au tour suivant :

```bash
dune exec -- ono symbolic test/cram/symbolic/life_config.t/center_alive_next.wat
```

Naissance du centre au tour suivant :

```bash
dune exec -- ono symbolic test/cram/symbolic/life_config.t/center_birth_next.wat
```

Ligne du milieu vivante au tour suivant :

```bash
dune exec -- ono symbolic test/cram/symbolic/life_config.t/row_middle_alive_next.wat
```

Oscillateur de période 2 :

```bash
dune exec -- ono symbolic test/cram/symbolic/life_config.t/oscillator_period_2.wat
```

Ces commandes déclenchent volontairement `unreachable` lorsque la contrainte est satisfaite. Le moteur symbolique affiche alors un `model`, qui correspond à une configuration initiale trouvée par le solveur.

### affichage graphique sous WSL

Si Raylib ne parvient pas à ouvrir la fenêtre graphique, les commandes suivantes peuvent être nécessaires avant le lancement :

```bash
unset LIBGL_ALWAYS_INDIRECT
export LIBGL_ALWAYS_SOFTWARE=1
```