# ⏱ Chrono Mac

Un petit chronomètre qui s'affiche dans la **barre des menus** du Mac (en haut de l'écran), avec les centièmes de seconde et la gestion des tours.

```
⏱ 00:12,47
```

## Fonctionnalités

- Temps affiché en direct dans la barre du haut (`MM:SS,cc`, puis `H:MM:SS,cc` au-delà d'une heure)
- **Démarrer / Arrêter / Reprendre**
- **Tour** : enregistre des temps intermédiaires (temps du tour + temps total)
- **Réinitialiser** : remet à zéro quand le chrono est arrêté
- Aucune icône dans le Dock, l'appli reste discrète
- Raccourcis quand le menu est ouvert : `⌘S` démarrer/arrêter, `⌘T` tour, `⌘R` réinitialiser, `⌘Q` quitter

## Configuration requise

- macOS 11 (Big Sur) ou plus récent
- Les outils de développement d'Apple (*Command Line Tools*), gratuits. Le script propose de les installer s'ils manquent.

## Installation

1. Ouvre le **Terminal** (⌘ + Espace, tape « Terminal », Entrée).
2. Colle cette commande et appuie sur Entrée :

   ```bash
   curl -fsSL https://raw.githubusercontent.com/rmili-abdelalim/chrono-mac/main/install.sh | bash
   ```

3. Si une fenêtre propose d'installer les **outils de développement**, clique sur **Installer**, attends la fin, puis relance la même commande.

Le script compile l'appli et l'installe dans `~/Applications/Chrono.app`, puis la lance. Le chrono apparaît dans la barre du haut.

### Installation manuelle (alternative)

```bash
git clone https://github.com/rmili-abdelalim/chrono-mac.git
cd chrono-mac
bash install.sh
```

## Utilisation

| Action | Comment faire |
|---|---|
| Ouvrir le menu | Clique sur ⏱ dans la barre du haut |
| Déplacer l'icône | Maintiens **⌘** et fais-la glisser dans la barre |
| Quitter | Menu → **Quitter le chronomètre** |
| Relancer | ⌘ + Espace → tape **Chrono** → Entrée |
| Lancer au démarrage du Mac | Réglages Système → Général → Ouverture → ajoute **Chrono** |

## Désinstallation

Quitte le chronomètre, puis dans le Terminal :

```bash
rm -rf ~/Applications/Chrono.app
```

## Contenu du dépôt

| Fichier | Rôle |
|---|---|
| `Chrono.swift` | Le code source de l'appli (Swift + AppKit) |
| `install.sh` | Script qui compile et installe l'appli |

## Licence

MIT, libre d'utilisation et de modification.
