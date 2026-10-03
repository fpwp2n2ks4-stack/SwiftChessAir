// Localization.swift
// Rôle du fichier : traduction français/anglais. Fournit `loc(_:)` et
// `loc(_:_:)` avec le même contrat que la version complète, en repli sur la
// clé elle-même si elle n'est pas trouvée. La langue active est persistée dans
// UserDefaults (défaut : langue du système).

import Foundation
import Combine

/// Langue prise en charge par l'application.
enum AppLanguage: String, CaseIterable, Identifiable {
    case fr
    case en

    var id: String { rawValue }

    /// Nom natif de la langue, affiché dans le sélecteur.
    var nativeName: String {
        self == .fr ? "Français" : "English"
    }
}

/// Gestion de la langue active : persistée dans UserDefaults, notifiée à chaque
/// changement pour que les vues et le menu se rafraîchissent.
final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    /// Notification postée quand la langue change.
    static let didChange = Notification.Name("languageDidChange")

    /// Langue active, persistée et notifiée à chaque modification.
    @Published var language: AppLanguage {
        didSet {
            guard language != oldValue else { return }
            UserDefaults.standard.set(language.rawValue, forKey: "appLanguage")
            NotificationCenter.default.post(name: Self.didChange, object: self)
        }
    }

    /// Initialise la langue depuis UserDefaults, sinon depuis le système.
    private init() {
        if let saved = UserDefaults.standard.string(forKey: "appLanguage"),
           let lang = AppLanguage(rawValue: saved) {
            self.language = lang
        } else {
            let preferred = Locale.preferredLanguages.first ?? "fr"
            self.language = preferred.lowercased().hasPrefix("fr") ? .fr : .en
        }
    }
}

/// Dictionnaire des chaînes localisées (clé → texte français).
private let frStrings: [String: String] = [
    "status.playerName": "Joueur",
    "status.starting": "Démarrage de la partie",
    "status.yourTurn": "À vous de jouer",
    "status.enginePlays": "%@ joue",
    "status.engineThinking": "%@ réfléchit",
    "status.engineFailed": "Échec du démarrage du moteur",
    "status.gameStopped": "Partie arrêtée",
    "status.gamePaused": "Partie en pause",
    "status.timeoutLoss": "Temps écoulé pour %@ — vous gagnez",
    "status.stalemate": "Pat",
    "status.check": "Échec !",
    "status.insufficientMaterial": "Matériel insuffisant",
    "status.checkmateWin": "Échec et mat — vous gagnez !",
    "status.checkmateLoss": "Échec et mat — %@ gagne",
    "status.seriesWin": "Vous remportez la série !",
    "status.seriesLoss": "%@ remporte la série",
    "status.seriesDraw": "Série nulle",
    "status.gameOver": "Fin de partie : %@",
    "status.notEnoughEngines": "Ajoutez au moins un moteur UCI.",
    "status.invalidEngineIndex": "Moteur invalide",
    "move.gameProgress": "Partie %d/%d",
    "swiftchessair.notConnected": "Échiquier non connecté",
    "swiftchessair.setup": "Remettez les pièces en position de départ…",
    "swiftchessair.syncError": "Erreur de synchronisation de l'échiquier",
    "swiftchessair.illegalMove": "Coup interdit — corrigez la position",
    "swiftchessair.illegalCheck": "Ce coup laisse votre roi en échec",
    "swiftchessair.gameEndPending": "Exécutez le coup final sur l'échiquier",
    "swiftchessair.scanning": "Recherche de l'échiquier…",
    "swiftchessair.connecting": "Connexion en cours…",
    "swiftchessair.bluetoothOff": "Bluetooth désactivé",
    "swiftchessair.bluetoothUnavailable": "Bluetooth indisponible",
    "swiftchessair.deviceLost": "Périphérique introuvable",
    "swiftchessair.connectFailed": "Échec de la connexion",
    "swiftchessair.unknownBoard": "Échiquier SwiftChessAir",
    "swiftchessair.connectFirst": "Connectez l'échiquier pour jouer.",
    "play.title": "Jouer sur SwiftChessAir contre un moteur UCI",
    "play.board": "Échiquier",
    "play.engine": "Moteur UCI",
    "play.engineNone": "Aucun moteur — ajoutez-en un",
    "play.cadence": "Cadence",
    "play.cadencePlayer": "Cadence (vous)",
    "play.cadenceEngine": "Cadence (moteur)",
    "play.color": "Couleur",
    "play.white": "Blancs",
    "play.black": "Noirs",
    "play.swap": "Alterner les couleurs",
    "play.games": "Nombre de parties",
    "play.leds": "LED de guidage",
    "play.analysis": "Afficher l'analyse",
    "play.options": "Options",
    "play.language": "Langue",
    "play.start": "Démarrer",
    "play.stop": "Arrêter",
    "play.pause": "Pause",
    "play.resume": "Reprendre",
    "play.exportPGN": "Exporter PGN",
    "play.addEngine": "Ajouter un moteur",
    "play.removeEngine": "Retirer le moteur",
    "engines.add.title": "Choisir le binaire du moteur UCI",
    "engine.options.button": "Paramètres du moteur…",
    "engine.options.title": "Paramètres du moteur UCI",
    "engine.options.refresh": "Récupérer",
    "engine.options.none": "Aucun paramètre déclaré par le moteur.",
    "engine.options.close": "Fermer",
    "engine.options.apply": "Appliquer",
    "engine.options.reset": "Réinitialiser",
    "engine.options.default": "défaut",
    "play.scan": "Scanner",
    "play.connect": "Connecter",
    "play.reconnect": "Reconnecter",
    "play.disconnect": "Déconnecter",
    "play.connected": "Connecté",
    "play.score": "Vous %d · Moteur %d · Nulles %d",
    "play.connecting": "Connexion…",
    "play.battery": "Batterie %d%%",
    "play.charging": " (en charge)",
    "pgn.filename": "partie-swiftchessair",
    "window.board.title": "Plateau",
    "window.controls.title": "Jouer",
    "menu.app.about": "À propos de SwiftChess Air",
    "menu.app.hide": "Masquer SwiftChessAir Air",
    "menu.app.hideOthers": "Masquer les autres",
    "menu.app.showAll": "Tout afficher",
    "menu.app.quit": "Quitter SwiftChessAir Air",
    "menu.edit": "Édition",
    "menu.edit.cut": "Couper",
    "menu.edit.copy": "Copier",
    "menu.edit.paste": "Coller",
    "menu.edit.selectAll": "Tout sélectionner",
    "menu.window": "Fenêtre",
    "menu.window.board": "Plateau",
    "menu.window.controls": "Commandes",
    "menu.window.minimize": "Réduire",
    "menu.window.zoom": "Zoom",
    "menu.window.close": "Fermer",
]

/// Dictionnaire des chaînes localisées (clé → texte anglais).
private let enStrings: [String: String] = [
    "status.playerName": "Player",
    "status.starting": "Starting the game",
    "status.yourTurn": "Your turn",
    "status.enginePlays": "%@ plays",
    "status.engineThinking": "%@ is thinking",
    "status.engineFailed": "Failed to start the engine",
    "status.gameStopped": "Game stopped",
    "status.gamePaused": "Game paused",
    "status.timeoutLoss": "Timeout for %@ — you win",
    "status.stalemate": "Stalemate",
    "status.check": "Check!",
    "status.insufficientMaterial": "Insufficient material",
    "status.checkmateWin": "Checkmate — you win!",
    "status.checkmateLoss": "Checkmate — %@ wins",
    "status.seriesWin": "You win the series!",
    "status.seriesLoss": "%@ wins the series",
    "status.seriesDraw": "Series drawn",
    "status.gameOver": "Game over: %@",
    "status.notEnoughEngines": "Add at least one UCI engine.",
    "status.invalidEngineIndex": "Invalid engine",
    "move.gameProgress": "Game %d/%d",
    "swiftchessair.notConnected": "Board not connected",
    "swiftchessair.setup": "Place the pieces in the starting position…",
    "swiftchessair.syncError": "Board synchronization error",
    "swiftchessair.illegalMove": "Illegal move — fix the position",
    "swiftchessair.illegalCheck": "This move leaves your king in check",
    "swiftchessair.gameEndPending": "Play the final move on the board",
    "swiftchessair.scanning": "Searching for the board…",
    "swiftchessair.connecting": "Connecting…",
    "swiftchessair.bluetoothOff": "Bluetooth disabled",
    "swiftchessair.bluetoothUnavailable": "Bluetooth unavailable",
    "swiftchessair.deviceLost": "Device not found",
    "swiftchessair.connectFailed": "Connection failed",
    "swiftchessair.unknownBoard": "SwiftChessAir board",
    "swiftchessair.connectFirst": "Connect the board to play.",
    "play.title": "Play on SwiftChessAir against a UCI engine",
    "play.board": "Board",
    "play.engine": "UCI engine",
    "play.engineNone": "No engine — add one",
    "play.cadence": "Time control",
    "play.cadencePlayer": "Time control (you)",
    "play.cadenceEngine": "Time control (engine)",
    "play.color": "Color",
    "play.white": "White",
    "play.black": "Black",
    "play.swap": "Alternate colors",
    "play.games": "Number of games",
    "play.leds": "Guide LEDs",
    "play.analysis": "Show analysis",
    "play.options": "Options",
    "play.language": "Language",
    "play.start": "Start",
    "play.stop": "Stop",
    "play.pause": "Pause",
    "play.resume": "Resume",
    "play.exportPGN": "Export PGN",
    "play.addEngine": "Add engine",
    "play.removeEngine": "Remove engine",
    "engines.add.title": "Choose the UCI engine binary",
    "engine.options.button": "Engine options…",
    "engine.options.title": "UCI engine options",
    "engine.options.refresh": "Fetch",
    "engine.options.none": "No options declared by the engine.",
    "engine.options.close": "Close",
    "engine.options.apply": "Apply",
    "engine.options.reset": "Reset",
    "engine.options.default": "default",
    "play.scan": "Scan",
    "play.connect": "Connect",
    "play.reconnect": "Reconnect",
    "play.disconnect": "Disconnect",
    "play.connected": "Connected",
    "play.score": "You %d · Engine %d · Draws %d",
    "play.connecting": "Connecting…",
    "play.battery": "Battery %d%%",
    "play.charging": " (charging)",
    "pgn.filename": "swiftchessair-game",
    "window.board.title": "Plateau",
    "window.controls.title": "Jouer",
    "menu.app.about": "About SwiftChess Air",
    "menu.app.hide": "Hide SwiftChessAir Air",
    "menu.app.hideOthers": "Hide Others",
    "menu.app.showAll": "Show All",
    "menu.app.quit": "Quit SwiftChessAir Air",
    "menu.edit": "Edit",
    "menu.edit.cut": "Cut",
    "menu.edit.copy": "Copy",
    "menu.edit.paste": "Paste",
    "menu.edit.selectAll": "Select All",
    "menu.window": "Window",
    "menu.window.board": "Board",
    "menu.window.controls": "Controls",
    "menu.window.minimize": "Minimize",
    "menu.window.zoom": "Zoom",
    "menu.window.close": "Close",
]

/// Dictionnaire des chaînes de la langue active.
private var activeStrings: [String: String] {
    LanguageManager.shared.language == .fr ? frStrings : enStrings
}

/// Traduit une clé dans la langue active.
func loc(_ key: String, comment: String = "") -> String {
    activeStrings[key] ?? key
}

/// Traduit une clé avec format (placeholders %@/%d, …).
func loc(_ key: String, _ args: CVarArg...) -> String {
    let format = activeStrings[key] ?? key
    return String(format: format, arguments: args)
}
