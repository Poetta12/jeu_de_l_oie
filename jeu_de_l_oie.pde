int numCases = 64; // Nombre de cases sur le plateau
int caseSize = 25; // Taille d'une case
int dice1 = 0; // Valeur du premier dé
int dice2 = 0; // Valeur du deuxième dé
int[] xCoords = new int[numCases]; // Tableau des coordonnées x de chaque case
int yCoord; // Coordonnée y des cases (fixe)
int numPlayers = 4; // Nombre de joueurs
int[] playerPositions = new int[numPlayers]; // Positions des joueurs sur le plateau
int currentPlayer = 0; // Indice du joueur en train de jouer
int currentPlayerWon = -1; // Variable pour suivre le joueur qui a gagné    
boolean gameOn = true; // Variable pour indiquer si le jeu est en cours ou terminé
boolean[] skipTurn = new boolean[numPlayers]; // Tableau pour indiquer si un joueur doit passer son tour
boolean[] inWell = new boolean[numPlayers]; // Tableau pour indiquer si un joueur est dans le puits
boolean[] inPrison = new boolean[numPlayers]; // Tableau pour indiquer si un joueur est en prison
String[] messages = new String[numPlayers]; // Messages spécifiques à chaque joueur
boolean playerWon = false; // Variable pour indiquer si un joueur a gagné

void setup() {
  size(1600, 600); // Taille de la fenêtre
  // Initialisation des coordonnées x de chaque case
  for (int i = 0; i < numCases; i++) {
    xCoords[i] = i * caseSize + caseSize / 2;
  }
  yCoord = 2 * height / 3; // Coordonnée y des cases (fixe)
  // Initialisation des positions des joueurs et des messages
  for (int i = 0; i < numPlayers; i++) {
    playerPositions[i] = 0;
    messages[i] = ""; // Initialiser les messages
  }
  drawBoard(); // Dessiner le plateau de jeu
  drawPlayers(); // Dessiner les pions des joueurs
  displayInfo(); // Afficher les informations des joueurs
}

void handleSpecialCases() {
  messages[currentPlayer] = ""; // Réinitialiser le message avant de gérer les cas spéciaux
  int playerPosition = playerPositions[currentPlayer]; // Position du joueur actuel sur le plateau
  // Gérer les différents cas spéciaux
  switch (playerPosition) {
    case 6:
      playerPositions[currentPlayer] = 12; // Avancer à la case 12
      messages[currentPlayer] = "Va à la case 12.";
      break;
    case 9:
    case 18:
    case 27:
    case 36:
    case 45:
    case 54:
      int extraMove = rollDice(); // Lancer un dé supplémentaire
      playerPositions[currentPlayer] += extraMove; // Avancer de la valeur du dé supplémentaire
      messages[currentPlayer] = "Avance encore de " + extraMove + " cases grâce à l'oie.";
      break;
    case 19:
      messages[currentPlayer] = "Est à l'hôtel et passe 1 tour."; // Passer un tour
      skipTurn[currentPlayer] = true;
      break;
    case 31:
      messages[currentPlayer] = "Est dans le puits et attend qu'un autre joueur tombe."; // Attendre qu'un autre joueur tombe
      inWell[currentPlayer] = true;
      break;
    case 42:
      playerPositions[currentPlayer] = 30; // Retourner à la case 30
      messages[currentPlayer] = "Est perdu dans le labyrinthe et retourne à la case 30.";
      break;
    case 52:
      messages[currentPlayer] = "Est en prison et attend qu'un autre joueur le libère."; // Attendre qu'un autre joueur le libère
      inPrison[currentPlayer] = true;
      skipTurn[currentPlayer] = true; // Le joueur ne peut pas jouer tant qu'il est en prison
      break;
    case 58:
      playerPositions[currentPlayer] = 0; // Retourner au début du plateau
      messages[currentPlayer] = "Tombe sur la tête de mort et recommence depuis le début.";
      break;
  }

  // Vérifier si un joueur en prison doit être libéré
  if (!inPrison[currentPlayer]) {
    for (int i = 0; i < numPlayers; i++) {
      if (i != currentPlayer && playerPositions[i] == playerPositions[currentPlayer] && inPrison[i]) {
        inPrison[i] = false; // Libérer le joueur en prison
        skipTurn[i] = false; // Permettre au joueur de rejouer
        messages[i] = "Est libéré de prison par Joueur " + (currentPlayer + 1) + ".";
      }
    }
  }

  // Vérifier si un joueur dans le puits doit être libéré
  if (!inWell[currentPlayer]) {
    for (int i = 0; i < numPlayers; i++) {
      if (i != currentPlayer && playerPositions[i] == playerPositions[currentPlayer] && inWell[i]) {
        inWell[i] = false; // Libérer le joueur dans le puits
        skipTurn[i] = false; // Permettre au joueur de rejouer
        messages[i] = "Est libéré du puits par Joueur " + (currentPlayer + 1) + ".";
      }
    }
  }
}

int rollDice() {
  dice1 = (int) random(1, 7); // Lancer le premier dé
  dice2 = (int) random(1, 7); // Lancer le deuxième dé
  return dice1 + dice2; // Retourner la somme des deux dés
}

void displayInfo() {
  fill(0); // Couleur du texte
  textSize(12); // Taille du texte
  textAlign(LEFT); // Alignement du texte
  int yOffset = 20; // Décalage vertical pour afficher les informations des joueurs
  // Afficher les informations de chaque joueur
  for (int i = 0; i < numPlayers; i++) {
    int xOffset = i * (width / numPlayers); // Calculer l'offset horizontal pour chaque joueur
    String playerInfo = "Joueur " + (i + 1) + " - Position: " + playerPositions[i];
    if (i == currentPlayer) {
      playerInfo += " (À vous de jouer)";
    }
    // Afficher les informations du joueur
    text(playerInfo, xOffset + 10, yOffset);
    text("Message: " + messages[i], xOffset + 10, yOffset + 20); // Afficher le message spécifique au joueur
    text("Résultat des dés: " + dice1 + " et " + dice2, xOffset + 10, yOffset + 40); // Afficher le résultat des dés
    text("Total: " + (dice1 + dice2), xOffset + 10, yOffset + 60); // Afficher le total des dés
  }
}

void drawBoard() {
  // Dessiner chaque case du plateau
  for (int i = 0; i < numCases; i++) {
    // Définir la couleur de remplissage en fonction du type de case
    if (i == 9 || i == 18 || i == 27 || i == 36 || i == 45 || i == 54) {
      fill(0, 255, 0); // Oie (vert)
    } else if (i == 19) {
      fill(255, 255, 0); // Hôtel (jaune)
    } else if (i == 31) {
      fill(0, 0, 255); // Puits (bleu)
    } else if (i == 42) {
      fill(255, 165, 0); // Labyrinthe (orange)
    } else if (i == 52) {
      fill(128, 128, 128); // Prison (gris)
    } else if (i == 58) {
      fill(255, 0, 0); // Tête de mort (rouge)
    } else {
      fill(255); // Cases normales (blanc)
    }
    // Dessiner la case
    rect(xCoords[i] - caseSize / 2, yCoord - caseSize / 2, caseSize, caseSize);
    fill(0);
    textSize(10);
    textAlign(LEFT);
    text(i, xCoords[i] - caseSize / 2 + 15, yCoord - caseSize / 2 + 9); // Afficher le numéro de la case
  }
}

void drawPlayers() {
  // Dessiner les pions de chaque joueur sur le plateau
  for (int i = 0; i < numPlayers; i++) {
    int playerCount = 0;
    // Compter le nombre de joueurs sur la même case que le joueur actuel
    for (int j = 0; j < numPlayers; j++) {
      if (playerPositions[j] == playerPositions[i]) {
        playerCount++;
      }
    }
    int offset = 16; // Décalage vertical pour les pions des joueurs sur la même case
    int positionIndex = 0;
    int col = 0; // Colonne (0 ou 1) pour l'affichage des pions 2 par 2
    for (int j = 0; j < numPlayers; j++) {
      // Dessiner le pion du joueur s'il est sur la même case que le joueur actuel
      if (playerPositions[j] == playerPositions[i]) {
        fill(200, 200, 200); // Couleur du pion
        rect(xCoords[playerPositions[j]] - caseSize / 2 + col * caseSize / 2, yCoord - caseSize / 2 + (positionIndex / 2) * offset, caseSize / 2, caseSize / 2); // Dessiner le pion
        fill(255, 0, 0); // Couleur du texte pour le numéro du joueur
        textSize(10); // Taille du texte
        textAlign(CENTER, CENTER); // Alignement du texte
        text("J" + (j + 1), xCoords[playerPositions[j]] - caseSize / 4 + col * caseSize / 2, yCoord - caseSize / 4 + (positionIndex / 2) * offset); // Afficher le numéro du joueur
        positionIndex++;
        col = (col + 1) % 2; // Alterner entre colonne 0 et 1 pour l'affichage des pions
      }
    }
  }
}

void draw() {
  background(255); // Effacer le contenu précédent à chaque frame
  displayInfo(); // Afficher les informations des joueurs
  drawBoard(); // Dessiner le plateau de jeu
  drawPlayers(); // Dessiner les pions des joueurs
  
  // Afficher le message de félicitations si un joueur a gagné
  if (playerWon) {
    fill(0); // Couleur du texte
    textSize(32); // Taille du texte
    textAlign(CENTER, CENTER); // Alignement du texte
    text("Félicitations! Joueur " + (currentPlayerWon + 1) + " a gagné!", width/2, height/2); // Afficher le message au centre de l'écran
  }
}

void keyPressed() {
  // Gérer les actions lorsqu'une touche est pressée
  if (key == ' ' && !skipTurn[currentPlayer] && !inPrison[currentPlayer] && gameOn) {
    // Lancer les dés si ce n'est pas le tour d'un joueur passé ou si le jeu est en cours
    dice1 = (int) random(1, 7); // Lancer le premier dé
    dice2 = (int) random(1, 7); // Lancer le deuxième dé
    int total = dice1 + dice2; // Calculer le total des dés
    println("Joueur " + (currentPlayer + 1) + " a lancé les dés: " + dice1 + " et " + dice2);
    println("Total: " + total);
    
    playerPositions[currentPlayer] += total; // Avancer le joueur selon le total des dés

    if (playerPositions[currentPlayer] >= 63) {
      playerPositions[currentPlayer] = 63; // Assurer que le joueur ne dépasse pas la dernière case
      playerWon = true; // Le joueur a gagné
      gameOn = false; // Le jeu est terminé
      currentPlayerWon = currentPlayer; // Mettre à jour le joueur gagnant
    }

    handleSpecialCases(); // Gérer les cas spéciaux

    if (playerPositions[currentPlayer] > 63) {
      playerPositions[currentPlayer] = 63; // Assurer que le joueur ne dépasse pas la dernière case
    } else if (playerPositions[currentPlayer] < 0) {
      playerPositions[currentPlayer] = 0; // Assurer que le joueur ne descend pas en dessous de la première case
    }

    currentPlayer = (currentPlayer + 1) % numPlayers; // Passer au joueur suivant
  } else if (key == ' ' && (skipTurn[currentPlayer] || inPrison[currentPlayer])) {
    if (inPrison[currentPlayer]) {
      messages[currentPlayer] = "Est toujours en prison.";
    }
    skipTurn[currentPlayer] = false; // Réinitialiser le passage de tour pour le joueur actuel
    currentPlayer = (currentPlayer + 1) % numPlayers; // Passer au joueur suivant
  }
}
