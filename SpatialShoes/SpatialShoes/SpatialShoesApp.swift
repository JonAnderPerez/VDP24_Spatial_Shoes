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
        WindowGroup {
            ContentView()
                .environment(shoesVM)
        }
    }
}
