//
//  DataTest.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import SwiftUI

struct DataTest: DataInteractor {
    var url: URL { Bundle.main.url(forResource: "Shoes", withExtension: "json")! }
}

extension ContentView {
    static var preview: some View {
        ContentView()
            .environment(ShoesViewModel(interactor: DataTest()))
    }
}

extension HomeView {
    static var preview: some View {
        HomeView()
            .environment(ShoesViewModel(interactor: DataTest()))
    }
}

extension HomeScrollView {
    static var preview: some View {
        HomeScrollView()
            .environment(ShoesViewModel(interactor: DataTest()))
    }
}

extension GalleryView {
    static var preview: some View {
        GalleryView()
            .environment(ShoesViewModel(interactor: DataTest()))
    }
}

extension FavView {
    static var preview: some View {
        FavView()
            .environment(ShoesViewModel(interactor: DataTest()))
    }
}

extension DetailView {
    static var preview: some View {
        DetailView(selectedShoe: .test)
            .environment(ShoesViewModel(interactor: DataTest()))
    }
}

extension Detail3DView {
    static var preview: some View {
        Detail3DView(selectedShoe: .test)
            .environment(ShoesViewModel(interactor: DataTest()))
    }
}

extension ShoeCard {
    static var preview: some View {
        ShoeCard(shoe: .test, isNavigationCard: false, rotate: false, isFav: false)
            .environment(ShoesViewModel(interactor: DataTest()))
    }
}

extension Shoe {
    static let test = Shoe(
        id: 10901,
        name: "Sky Dunk",
        brand: "Athletica",
        size: [
            40,
            41,
            42,
            43,
            44,
            45
        ],
        price: 199.99,
        description: "Domina la cancha con nuestras Sky Dunk de Athletica. Diseñadas para los amantes del baloncesto, estas zapatillas ofrecen una combinación ideal de soporte, durabilidad y estilo. Inspiradas en los clásicos del baloncesto, las Sky Dunk están listas para elevar tu juego.\nCaracterísticas destacadas:\n- Material: Construcción en cuero y malla para un equilibrio perfecto entre soporte y transpirabilidad.\n- Diseño: Estilo icónico y moderno, ideal para destacar en la cancha.\n- Comodidad: Amortiguación avanzada y soporte en el tobillo para movimientos rápidos y saltos explosivos.\n- Versatilidad: Perfectas para entrenamientos, partidos y uso casual. Disponibles en varias tallas.\nLleva tu juego al siguiente nivel con nuestras Sky Dunk y siente la diferencia en cada salto y aterrizaje.",
        model3DName: "AirJordan",
        type: "Deportivas",
        materials: [
            "Cuero"
        ],
        origin: "Japón",
        gender: "Unisex",
        weight: 1.2,
        colors: [
            .red,
            .white,
            .black
        ],
        warranty: 2,
        certifications: [
            "Producto Ecológico",
            "Certificación de Calidad"
        ],
        isFav: false
    )
}
