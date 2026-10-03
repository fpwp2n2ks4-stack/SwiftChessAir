// ObservableValue.swift
// Rôle du fichier : conteneur de valeur observable utilisé à la place de @State
// tant que le plugin SwiftUIMacros n'est pas disponible.
//
// CONTEXTE : sur macOS 27 et ultérieur, @State est une macro fournie avec Xcode.
// Les Command Line Tools seules ne la fournissent pas, ce qui rend le projet
// non compilable sans Xcode. Comme @StateObject et @Binding fonctionnent toujours,
// on stocke la valeur dans un ObservableObject.
//
// ATTENTION : ce fichier est un palliatif de compatibilité, pas une amélioration.
// Migrer vers @State dès que Xcode est disponible (voir README, « Prérequis ») :
//   @StateObject private var x = ObservableValue(0)  +  x.value          ->  @State private var x = 0
//   x.binding                                        ->  $x
//
// Retirer ce fichier et les trois usages dès que le projet compile directement.

import SwiftUI

/// Conteneur observable générique, équivalent de `@State` pour une valeur isolée.
final class ObservableValue<Value>: ObservableObject {

    /// La valeur stockée ; toute écriture invalide la vue.
    @Published var value: Value

    /// Crée un conteneur autour d'une valeur initiale.
    init(_ value: Value) {
        self.value = value
    }

    /// Projection `Binding`, pour les modifieurs qui attendent un `Binding`
    /// (`.sheet(isPresented:)`, `.toggleStyle`, etc.).
    var binding: Binding<Value> {
        Binding(get: { self.value }, set: { self.value = $0 })
    }
}