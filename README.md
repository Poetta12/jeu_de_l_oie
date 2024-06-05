# Jeu de l'oie

Bienvenue dans le jeu de l'oie ! Ce jeu est une adaptation numérique du célèbre jeu de plateau. Le but du jeu est d'atteindre la dernière case du plateau avant les autres joueurs.

## Règles du jeu

- Le plateau contient 63 cases.
- Chaque joueur lance les dés à son tour et avance du nombre de cases correspondant à la somme des dés.
- Certaines cases ont des effets spéciaux :
  - Case 6 : Avancer à la case 12.
  - Cases 9, 18, 27, 36, 45, 54 : Avancer du nombre de cases indiqué par un lancer de dé supplémentaire (cases de l'oie).
  - Case 19 : Hôtel, le joueur passe un tour.
  - Case 31 : Puits, le joueur attend qu'un autre joueur tombe dans le puits pour sortir.
  - Case 42 : Labyrinthe, le joueur retourne à la case 30.
  - Case 52 : Prison, le joueur attend qu'un autre joueur le libère.
  - Case 58 : Tête de mort, le joueur retourne à la case de départ.

## Fonctionnalités

- Interface graphique pour visualiser le plateau de jeu et les positions des joueurs.
- Affichage des messages spécifiques pour chaque joueur en fonction des cases spéciales.
- Gestion des tours de chaque joueur et des conditions de victoire.

## Configuration

### Variables

- `int numCases = 64;` : Nombre de cases sur le plateau.
- `int caseSize = 25;` : Taille d'une case.
- `int dice1 = 0;` : Valeur du premier dé.
- `int dice2 = 0;` : Valeur du deuxième dé.
- `int[] xCoords = new int[numCases];` : Tableau des coordonnées x de chaque case.
- `int yCoord;` : Coordonnée y des cases (fixe).
- `int numPlayers = 4;` : Nombre de joueurs.
- `int[] playerPositions = new int[numPlayers];` : Positions des joueurs sur le plateau.
- `int currentPlayer = 0;` : Indice du joueur en train de jouer.
- `int currentPlayerWon = -1;` : Variable pour suivre le joueur qui a gagné.
- `boolean gameOn = true;` : Variable pour indiquer si le jeu est en cours ou terminé.
- `boolean[] skipTurn = new boolean[numPlayers];` : Tableau pour indiquer si un joueur doit passer son tour.
- `boolean[] inWell = new boolean[numPlayers];` : Tableau pour indiquer si un joueur est dans le puits.
- `String[] messages = new String[numPlayers];` : Messages spécifiques à chaque joueur.
- `boolean playerWon = false;` : Variable pour indiquer si un joueur a gagné.

## Fonctionnalités du Code

### Initialisation

La fonction `setup()` initialise les coordonnées du plateau, les positions des joueurs et les messages spécifiques pour chaque joueur. Elle dessine également le plateau de jeu et les pions des joueurs.

### Cas Spéciaux

La fonction `handleSpecialCases()` gère les différents cas spéciaux en fonction de la position actuelle du joueur sur le plateau.

### Lancer de Dés

La fonction `rollDice()` simule le lancer de deux dés et retourne la somme des deux valeurs.

### Affichage des Informations

La fonction `displayInfo()` affiche les informations de chaque joueur, y compris la position, le message spécifique, et les résultats des dés.

### Dessiner le Plateau

La fonction `drawBoard()` dessine les cases du plateau, en utilisant différentes couleurs pour les cases spéciales.

### Dessiner les Joueurs

La fonction `drawPlayers()` dessine les pions des joueurs sur le plateau.

### Mise à Jour de l'Écran

La fonction `draw()` met à jour l'affichage du plateau de jeu et des pions à chaque frame, et affiche un message de félicitations lorsque un joueur gagne.

### Gestion des Touche Pressées

La fonction `keyPressed()` gère les actions lorsqu'une touche est pressée, notamment le lancer de dés et le passage au joueur suivant.

## Comment Jouer

1. Lancer Processing et ouvrir le fichier `.pde` contenant le code du jeu.
2. Exécuter le programme.
3. Appuyer sur la barre d'espace pour lancer les dés à chaque tour.
4. Suivre les instructions affichées à l'écran en fonction des cases spéciales.

## Crédits

Ce jeu a été développé en utilisant le langage de programmation Java (from Processing).

By Poetta@PoettaTech_FSDS | 2024 | Campus Numérique in the Alps














Explications des modifications :
Prison (Case 52) : Lorsqu'un joueur atterrit sur la case 52, il est mis en prison (inPrison[currentPlayer] = true;) et son tour est passé (skipTurn[currentPlayer] = true;). Il doit attendre qu'un autre joueur atterrisse sur la même case pour être libéré.

Libération de la prison et du puits : Lorsque ce n'est pas le tour d'un joueur en prison ou dans le puits, la fonction handleSpecialCases() vérifie si un autre joueur est sur la même case et le libère si c'est le cas.

Lancer des dés et gestion des tours : Le joueur ne peut lancer les dés que s'il n'est pas en train de passer son tour et n'est pas en prison (!skipTurn[currentPlayer] && !inPrison[currentPlayer]).

Affichage des messages : Les messages sont mis à jour pour refléter l'état des joueurs, notamment lorsqu'ils sont en prison ou dans le puits.
