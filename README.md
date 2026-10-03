# SwiftChessAir

Application macOS pour jouer contre un moteur UCI **exclusivement sur un échiquier physique Chessnut** (Air, Air+, Go, Pro) via Bluetooth.

> Una aplicación macOS para jugar contra un motor UCI **exclusivamente en un tablero físico de Chessnut** (Air, Air+, Go, Pro) a través de Bluetooth.

---

## 🇫🇷 Français

### Fonctionnalités

- **Échiquier physique uniquement** : détection, connexion Bluetooth et flux de position en temps réel (pas de clic-souris, vous jouez sur le plateau).
- **Moteurs UCI** : ajout / suppression de moteurs (binaire), récupération et modification des paramètres UCI (`check`, `spin`, `combo`, `string`, `button`).
- **Cadences** indépendantes pour le joueur et le moteur (1s à 60 min, avec ou sans incrément).
- **Couleurs** : Blancs / Noirs, avec alternance automatique des couleurs sur plusieurs parties.
- **Séries de parties** (1 à 10) avec score cumulé.
- **LED de guidage** sur l'échiquier pour indiquer le coup du moteur.
- **Analyse en direct** du moteur (profondeur, score, variante) dans le bandeau du plateau.
- **Alertes sonores et visuelles** : échec au roi, échec et mat, pat et coup interdit (avec explication quand le coup laisse le roi en échec).
- **Interface français / anglais**, langue réglable (défaut : langue du système).

### Prérequis

- macOS 13 (Ventura) ou ultérieur.
- [Swift 5.9+](https://www.swift.org/) / Swift Package Manager.
- **Ni Xcode ni paquet supplémentaire** : la compilation fonctionne avec les seules Command Line Tools (voir « Compatibilité » ci-dessous).
- Un échiquier SwiftChessAir (Air, Air+, Go ou Pro) allumé.
- Autorisation Bluetooth accordée à l'application (demandée au premier lancement).

**Compatibilité macOS 27 et ultérieurs.** Apple a fait de `@State` une macro dans son SDK 27, mais n'a pas embarqué le plugin correspondant dans les Command Line Tools : celui-ci n'est fourni qu'avec Xcode. Un code SwiftUI utilisant `@State` ne compile donc plus en ligne de commande. Pour ne pas imposer Xcode, ce dépôt n'utilise plus `@State` : les deux usages d'origine ont été remplacés par `@StateObject` et un petit conteneur `ObservableValue` (`Sources/SwiftChessAir/ObservableValue.swift`). Le dépôt compile ainsi avec les seules Command Line Tools, sans Xcode. C'est **vérifié sur macOS 27** (compilation et lancement) ; sur **macOS 26 et antérieurs, c'est attendu mais non testé** — le code n'utilise plus `@State` et ne dépend d'aucune API réservée au SDK 27.

> **Note.** C'est un **palliatif de compatibilité, pas une amélioration** : `@StateObject` pour une valeur isolée est moins idiomatique. Si vous préférez `@State`, installez Xcode (`xcode-select -s /Applications/Xcode.app/Contents/Developer`), puis revenez à `@State` dans `PlayView.swift` et `ChessBoardView.swift` et supprimez `ObservableValue.swift` — les équivalences sont indiquées en tête de fichier. Ce n'est nécessaire que si vous compilez une **version antérieure** du dépôt, qui utilisait `@State` : sur macOS 27 et ultérieurs, Xcode sera alors requis.

### Compilation et lancement

```bash
./build-app.sh     # compile en release et empaquette SwiftChessAir.app
open SwiftChessAir.app
```

Au premier lancement, acceptez l'accès Bluetooth. Connectez l'échiquier avec le bouton « Scanner », puis ajoutez un moteur UCI avec « Ajouter un moteur » (sélectionnez le binaire, par ex. `stockfish`).

### Utilisation

1. **Scanner** pour trouver l'échiquier, puis **Connecter**.
2. **Ajouter un moteur** UCI (le nom apparaît alors dans le menu déroulant).
3. Choisissez les **cadences**, la **couleur** et le **nombre de parties**.
4. **Démarrer**. Remettez les pièces en position de départ quand demandé, puis jouez vos coups sur l'échiquier : le moteur répond et ses LED indiquent son coup.

### Structure du projet

| Fichier | Rôle |
| --- | --- |
| `SwiftChessAirBoard.swift` | Pilote Bluetooth (Core Bluetooth) de l'échiquier SwiftChessAir |
| `PlayController.swift` | Orchestration d'une partie (flux FEN, horloges, fin de partie) |
| `ChessGame.swift` | Règles, FEN, détection des coups, coups légaux |
| `Engine.swift` / `EngineManager.swift` | Moteur UCI (processus) et persistance de la liste |
| `EngineOptionsView.swift` | Édition des options UCI du moteur |
| `ChessBoardView.swift` | Rendu SwiftUI de l'échiquier + bandeau d'analyse |
| `PlayView.swift` | Panneau de commandes (connexion, moteur, cadences, actions) |
| `Localization.swift` | Traductions français / anglais |
| `ObservableValue.swift` | Conteneur de valeur observable (contournement de `@State`, macOS 27 sans Xcode) |
| `Resources/AppIcon.icns` | Icône de l'application (Dock et panneau « À propos ») |
| `build-app.sh` | Compilation release + empaquetage `SwiftChessAir.app` (Info.plist Bluetooth, icône) |

### Licence

Distribué sous [licence MIT](LICENSE).

### Remerciements

Ce projet s'appuie sur l'API officielle des échiquiers Chessnut, disponible à l'adresse : <https://github.com/chessnutech/EasyLinkSDK>

---
## 🇪🇸 Español

### Características

- **Solo tablero físico**: detección, conexión Bluetooth y flujo de posición en tiempo real (sin clics del ratón, juegas directamente sobre el tablero).
- **Motores UCI**: añadir/eliminar motores (binarios), consultar y editar opciones UCI (`check`, `spin`, `combo`, `string`, `button`).
- **Controles de tiempo independientes** para el jugador y el motor (1s a 60 min, con o sin incremento).
- **Colores**: blancas/negras, con alternancia automática de colores entre partidas.
- **Series de partidas** (1 a 10 partidas) con puntuación acumulada.
- **LEDs guía** en el tablero para mostrar el movimiento del motor.
- **Análisis en tiempo real** del motor (profundidad, puntuación, línea principal) en la barra de estado del tablero.
- **Alertas sonoras y visuales**: jaque, jaque mate, ahogado y movimiento ilegal (con explicación cuando el movimiento deja al rey en jaque).
- **Interfaz francés / inglés / español**, seleccionable (por defecto, idioma del sistema).

### Requisitos

- macOS 13 (Ventura) o posterior.
- [Swift 5.9+](https://www.swift.org/) / Swift Package Manager.
- **Ni Xcode ni paquetes adicionales**: la compilación funciona con las solo Command Line Tools (véase «Compatibilidad» más abajo).
- Un tablero SwiftChessAir (Air, Air+, Go o Pro) encendido.
- Permiso de Bluetooth concedido a la aplicación (solicitado al primer inicio).

**Compatibilidad con macOS 27 y posteriores.** Apple convirtió `@State` en una macro en su SDK 27, pero no incorporó el complemento correspondiente en las Command Line Tools: ese solo se distribuye con Xcode. Por tanto, el código SwiftUI que usa `@State` ya no compila en línea de comandos. Para no imponer Xcode, este repositorio ya no usa `@State`: los dos usos originales se sustituyeron por `@StateObject` y un pequeño contenedor `ObservableValue` (`Sources/SwiftChessAir/ObservableValue.swift`). Así, el repositorio compila con las solo Command Line Tools, sin Xcode. Está **verificado en macOS 27** (compilación y arranque); en **macOS 26 y anteriores se espera que funcione, pero no está probado**: el código ya no usa `@State` ni depende de ninguna API exclusiva del SDK 27.

> **Nota.** Esto es un **parche de compatibilidad, no una mejora**: `@StateObject` para un valor aislado es menos idiomático. Si prefiere `@State`, instale Xcode (`xcode-select -s /Applications/Xcode.app/Contents/Developer`), vuelva a `@State` en `PlayView.swift` y `ChessBoardView.swift` y elimine `ObservableValue.swift`: las equivalencias están indicadas al principio del archivo. Solo es necesario si compila una **versión anterior** del repositorio, que usaba `@State`: en macOS 27 y posteriores, Xcode será entonces requerido.

> **Nota.** Para que el repositorio compile de todos modos sin Xcode, los dos usos de `@State` se sustituyeron por `@StateObject` y un pequeño contenedor `ObservableValue` (`Sources/SwiftChessAir/ObservableValue.swift`). Es un **parche de compatibilidad, no una mejora**: `@StateObject` para un valor aislado es menos idiomático y solo hace falta mientras Xcode no esté instalado. En cuanto tengas Xcode, vuelve a `@State` y elimina ese archivo: las equivalencias están indicadas al principio del archivo.

### Compilación y ejecución

```bash
./build-app.sh     # compilación en release y empaquetado de SwiftChessAir.app
open SwiftChessAir.app
```

Al primer inicio, acepta el permiso de Bluetooth. Busca tu tablero con el botón **Escanear**, luego añade un motor UCI con **Añadir motor** (selecciona el binario, p. ej. `stockfish`).

### Uso

1. **Escanear** para encontrar el tablero, luego **Conectar**.
2. **Añadir un motor** UCI (aparecerá en el desplegable).
3. Elige los **controles de tiempo**, el **color** y el **número de partidas**.
4. **Empezar**. Coloca las piezas en posición inicial cuando se te solicite, luego juega tus movimientos sobre el tablero: el motor responderá y sus LEDs mostrarán su movimiento.

### Estructura del proyecto

| Archivo | Función |
| --- | --- |
| `SwiftChessAirBoard.swift` | Controlador Bluetooth (Core Bluetooth) para el tablero SwiftChessAir |
| `PlayController.swift` | Orquestación de la partida (flujo FEN, relojes, fin de partida) |
| `ChessGame.swift` | Reglas, FEN, detección de movimientos, movimientos legales |
| `Engine.swift` / `EngineManager.swift` | Motor UCI (proceso) y persistencia de la lista de motores |
| `EngineOptionsView.swift` | Edición de opciones UCI del motor |
| `ChessBoardView.swift` | Renderizado SwiftUI del tablero + barra de análisis |
| `PlayView.swift` | Panel de controles (conexión, motor, tiempo, acciones) |
| `Localization.swift` | Traducciones (francés / inglés) |
| `ObservableValue.swift` | Contenedor de valor observable (sustituto de `@State`, macOS 27 sin Xcode) |
| `Resources/AppIcon.icns` | Icono de la aplicación (Dock y panel «Acerca de») |
| `build-app.sh` | Compilación release + empaquetado `SwiftChessAir.app` (Info.plist Bluetooth, icono) |

### Licencia

Distribuido bajo [licencia MIT](LICENSE).

### Agradecimientos

Este proyecto se basa en la API oficial de los tableros Chessnut, disponible en: <https://github.com/chessnutech/EasyLinkSDK>

---
## 🇬🇧 English

### Features

- **Physical board only**: Bluetooth detection, connection and real-time position stream (no mouse input — you play on the board).
- **UCI engines**: add / remove engines (binary), fetch and edit UCI options (`check`, `spin`, `combo`, `string`, `button`).
- Independent **time controls** for the player and the engine (1s to 60 min, with or without increment).
- **Colors**: White / Black, with automatic color alternation over several games.
- **Game series** (1 to 10 games) with cumulative score.
- **Guide LEDs** on the board to show the engine's move.
- **Live analysis** from the engine (depth, score, principal variation) in the board's status bar.
- **Sound and visual alerts**: check, checkmate, stalemate and illegal move (with an explanation when the move leaves your king in check).
- **French / English UI**, switchable (defaults to the system language).

### Requirements

- macOS 13 (Ventura) or later.
- [Swift 5.9+](https://www.swift.org/) / Swift Package Manager.
- **No Xcode and no extra packages needed**: the build works with the Command Line Tools alone (see "Compatibility" below).
- A SwiftChessAir board (Air, Air+, Go or Pro), powered on.
- Bluetooth permission granted to the app (prompted on first launch).

**Compatibility with macOS 27 and later.** Apple turned `@State` into a macro in its macOS 27 SDK, but did not bundle the matching plugin in the Command Line Tools: it ships with Xcode only. SwiftUI code using `@State` therefore no longer builds from the command line. To avoid requiring Xcode, this repository no longer uses `@State`: the two original uses were replaced by `@StateObject` and a small `ObservableValue` container (`Sources/SwiftChessAir/ObservableValue.swift`). The repository now builds with the Command Line Tools alone, without Xcode. This is **verified on macOS 27** (build and launch); on **macOS 26 and earlier it is expected to work but untested** — the code no longer uses `@State` and depends on no API reserved to the SDK 27.

> **Note.** This is a **compatibility workaround, not an improvement**: `@StateObject` for a single value is less idiomatic. If you prefer `@State`, install Xcode (`xcode-select -s /Applications/Xcode.app/Contents/Developer`), then switch `PlayView.swift` and `ChessBoardView.swift` back to `@State` and delete `ObservableValue.swift` — the equivalents are listed at the top of the file. This is only necessary if you build an **earlier version** of the repository, which used `@State`: on macOS 27 and later, Xcode will then be required.

### Build & run

```bash
./build-app.sh     # release build + SwiftChessAir.app packaging
open SwiftChessAir.app
```

On first launch, accept the Bluetooth permission. Find your board with the **Scan** button, then add a UCI engine with **Add engine** (pick the binary, e.g. `stockfish`).

### Usage

1. **Scan** to find the board, then **Connect**.
2. **Add an engine** (it then appears in the dropdown).
3. Pick the **time controls**, the **color** and the **number of games**.
4. **Start**. Place the pieces in the starting position when asked, then play your moves on the board: the engine replies and its LEDs show its move.

### Project layout

| File | Purpose |
| --- | --- |
| `SwiftChessAirBoard.swift` | Bluetooth driver (Core Bluetooth) for the SwiftChessAir board |
| `PlayController.swift` | Game orchestration (FEN stream, clocks, game end) |
| `ChessGame.swift` | Rules, FEN, move detection, legal moves |
| `Engine.swift` / `EngineManager.swift` | UCI engine (process) and engine list persistence |
| `EngineOptionsView.swift` | UCI engine option editing |
| `ChessBoardView.swift` | SwiftUI board rendering + analysis bar |
| `PlayView.swift` | Controls panel (connection, engine, time, actions) |
| `Localization.swift` | French / English translations |
| `ObservableValue.swift` | Observable value container (`@State` workaround, macOS 27 without Xcode) |
| `Resources/AppIcon.icns` | Application icon (Dock and About panel) |
| `build-app.sh` | Release build + `SwiftChessAir.app` packaging (Bluetooth Info.plist, icon) |

### License

Released under the [MIT license](LICENSE).

### Acknowledgements

This project is based on the official Chessnut board API, available at: <https://github.com/chessnutech/EasyLinkSDK>

---

