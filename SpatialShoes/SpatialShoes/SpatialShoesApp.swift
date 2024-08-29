//
//  SpatialShoesApp.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import SwiftUI

@main
struct SpatialShoesApp: App {
    @State private var shoesVM = ShoesViewModel()
    
    var body: some Scene {
        // TabView principal
        WindowGroup(id: "MainContent") {
            ContentView()
                .environment(shoesVM)
        }
        
        // Scroll de items para la home
        WindowGroup(id: "HomeScrollView") {
            HomeScrollView()
                .environment(shoesVM)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        //.defaultPosition(.bottom) //TODO: Para VisionOS 2.0
        
        // Pantalla volumetrica para el detalle de los zapatos
        WindowGroup(id: "ShoeDetail3D", for: Shoe.self) { $selectedShoe in
            Detail3DView(selectedShoe: selectedShoe)
                .environment(shoesVM)
        } defaultValue: {
            .test
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)
        //.defaultPosition(.trailing) //TODO: Para VisionOS 2.0
        
        // Espacio immersivo para el showroom
        ImmersiveSpace(id: "ImmersiveShowRoom") {
            ShowRoomView()
                .environment(shoesVM)
        }
        .immersiveContentBrightness(.bright)
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
        
        // Espacio immersivo de una tienda de ropa
        ImmersiveSpace(id: "Store") {
            StoreView()
        }
        .immersiveContentBrightness(.bright)
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
