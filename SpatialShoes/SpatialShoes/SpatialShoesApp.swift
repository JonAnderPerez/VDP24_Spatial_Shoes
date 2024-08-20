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
        WindowGroup() {
            ContentView()
                .environment(shoesVM)
        }
        
        WindowGroup(id: "ShoeDetail3D", for: Shoe.self) { $selectedShoe in
            Detail3DView(selectedShoe: selectedShoe)
                .environment(shoesVM)
        } defaultValue: {
            .test
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)
    }
}
