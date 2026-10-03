// swift-tools-version: 5.9
// SwiftChessAir — application macOS minimale : jouer exclusivement sur l'échiquier
// physique SwiftChessAir (Bluetooth) contre un moteur UCI, avec choix de la cadence,
// des couleurs et du nombre de parties.
//
import PackageDescription

let package = Package(
    name: "SwiftChessAir",
    defaultLocalization: "fr",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "SwiftChessAir",
            path: "Sources/SwiftChessAir",
            resources: [.process("Resources")]
        )
    ]
)
