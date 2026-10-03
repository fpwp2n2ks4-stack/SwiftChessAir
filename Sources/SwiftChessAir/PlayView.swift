// PlayView.swift
// Rôle du fichier : panneau de contrôle d'une partie sur l'échiquier physique
// SwiftChessAir contre un moteur UCI — connexion Bluetooth, choix du moteur, des
// cadences, des couleurs et du nombre de parties, puis démarrage/arrêt et
// suivi du score.

import SwiftUI

/// Panneau de contrôle de la partie SwiftChessAir vs Moteur.
struct PlayView: View {
    @ObservedObject var play: PlayController
    @ObservedObject private var language = LanguageManager.shared
    @StateObject private var showEngineOptions = ObservableValue(false)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                connectionSection
                engineSection
                timeSection
                colorSection
                optionsSection
                languageSection
                actionsSection
                scoreSection
            }
            .padding(14)
        }
        .frame(minWidth: 300)
        .sheet(isPresented: showEngineOptions.binding) {
            if let engine = play.selectedEngine {
                EngineOptionsView(engine: engine)
            }
        }
    }

    // MARK: - Connexion Bluetooth

    private var connectionSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(loc("play.board")).font(.headline)

            HStack {
                Circle()
                    .fill(connectionColor)
                    .frame(width: 10, height: 10)
                Text(connectionText)
                    .fontWeight(.medium)
                Spacer()
            }

            HStack(spacing: 8) {
                if play.swiftchessair.state.isConnected {
                    Button(loc("play.disconnect")) { play.swiftchessair.disconnect() }
                    Button(loc("play.reconnect")) { _ = play.swiftchessair.reconnectLast() }
                } else {
                    Button(loc("play.scan")) { play.swiftchessair.startScan() }
                }
            }

            if play.swiftchessair.batteryPercent >= 0 {
                Text(String(format: loc("play.battery"), play.swiftchessair.batteryPercent) + (play.swiftchessair.isCharging ? loc("play.charging") : ""))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if !play.swiftchessair.errorMessage.isEmpty {
                Text(play.swiftchessair.errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            if !play.swiftchessair.devices.isEmpty {
                ForEach(play.swiftchessair.devices) { device in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(device.name)
                                .font(.callout)
                            Text("\(device.rssi) dBm")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button(loc("play.connect")) { play.swiftchessair.connect(to: device) }
                            .disabled(play.swiftchessair.state == .connecting)
                    }
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .controlBackgroundColor)))
    }

    private var connectionText: String {
        switch play.swiftchessair.state {
        case .idle: return play.swiftchessair.connectedName.isEmpty ? loc("swiftchessair.notConnected") : play.swiftchessair.connectedName
        case .scanning: return loc("swiftchessair.scanning")
        case .connecting: return loc("swiftchessair.connecting")
        case .connected: return play.swiftchessair.connectedName
        }
    }

    private var connectionColor: Color {
        play.swiftchessair.state.isConnected ? .green : (play.swiftchessair.state == .idle ? .gray : .orange)
    }

    // MARK: - Moteur

    private var engineSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(loc("play.engine")).font(.headline)

            if play.engineManager.engines.isEmpty {
                Text(loc("play.engineNone"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Picker("", selection: $play.engineIndex) {
                    ForEach(play.engineManager.engines.indices, id: \.self) { i in
                        Text(play.engineManager.engines[i].name).tag(i)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 8) {
                Button(loc("play.addEngine")) { addEngine() }
                if play.engineManager.engines.indices.contains(play.engineIndex) {
                    Button(loc("play.removeEngine")) { removeSelectedEngine() }
                }
                Spacer()
                if play.selectedEngine != nil {
                    Button(loc("engine.options.button")) { showEngineOptions.value = true }
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .controlBackgroundColor)))
    }

    /// Ouvre le sélecteur de fichier pour choisir un binaire de moteur UCI.
    private func addEngine() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.message = loc("engines.add.title")
        if panel.runModal() == .OK, let url = panel.url {
            let name = url.deletingPathExtension().lastPathComponent
            play.engineManager.addEngine(name: name, path: url.path)
            play.engineIndex = play.engineManager.engines.count - 1
        }
    }

    /// Retire le moteur sélectionné et réajuste la sélection.
    private func removeSelectedEngine() {
        guard play.engineManager.engines.indices.contains(play.engineIndex) else { return }
        let engine = play.engineManager.engines[play.engineIndex]
        play.engineManager.removeEngine(engine)
        play.engineIndex = max(0, min(play.engineIndex, play.engineManager.engines.count - 1))
    }

    // MARK: - Cadences

    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(loc("play.cadence")).font(.headline)

            HStack {
                Text(loc("play.cadencePlayer"))
                Spacer()
                Picker("", selection: $play.playerTC) {
                    ForEach(TimeControlOption.all) { tc in
                        Text(tc.name).tag(tc)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 180)
            }

            HStack {
                Text(loc("play.cadenceEngine"))
                Spacer()
                Picker("", selection: $play.engineTC) {
                    ForEach(TimeControlOption.all) { tc in
                        Text(tc.name).tag(tc)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 180)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .controlBackgroundColor)))
    }

    // MARK: - Couleur

    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(loc("play.color")).font(.headline)

            Picker("", selection: $play.humanPlaysWhite) {
                Text(loc("play.white")).tag(true)
                Text(loc("play.black")).tag(false)
            }
            .pickerStyle(.segmented)

            Toggle(loc("play.swap"), isOn: $play.swapColors)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .controlBackgroundColor)))
    }

    // MARK: - Options

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(loc("play.options")).font(.headline)

            HStack {
                Text(loc("play.games"))
                Spacer()
                Stepper("\(play.numberOfGames)", value: $play.numberOfGames, in: 1...10)
            }

            Toggle(loc("play.leds"), isOn: $play.showLEDs)
            Toggle(loc("play.analysis"), isOn: $play.showAnalysis)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .controlBackgroundColor)))
    }

    // MARK: - Langue

    private var languageSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(loc("play.language")).font(.headline)

            Picker("", selection: $language.language) {
                ForEach(AppLanguage.allCases) { lang in
                    Text(lang.nativeName).tag(lang)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .controlBackgroundColor)))
    }

    // MARK: - Actions

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                if play.isRunning {
                    Button(loc("play.stop")) { play.stop() }
                        .buttonStyle(.borderedProminent)
                    Button(play.isPaused ? loc("play.resume") : loc("play.pause")) { play.isPaused ? play.resume() : play.pause() }
                } else {
                    Button(loc("play.start")) { play.start() }
                        .buttonStyle(.borderedProminent)
                        .disabled(!play.canStart)
                }
            }

            if !play.statusMessage.isEmpty {
                Text(play.statusMessage)
                    .font(.callout)
                    .foregroundStyle(statusColor)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .controlBackgroundColor)))
    }

    private var statusColor: Color {
        play.statusMessage.contains("!") ? .green : .primary
    }

    // MARK: - Score

    private var scoreSection: some View {
        HStack {
            Text(String(format: loc("play.score"), play.humanWins, play.engineWins, play.draws))
                .font(.headline)
                .monospacedDigit()
            Spacer()
            if play.isRunning {
                Text(String(format: loc("move.gameProgress"), play.currentGameNumber, play.numberOfGames))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .controlBackgroundColor)))
    }
}
