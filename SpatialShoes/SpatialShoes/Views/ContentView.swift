//
//  ContentView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @Environment(ShoesViewModel.self) private var vm
    
    var body: some View {
        @Bindable var vmBindable = vm
        TabView {
            HomeView()
                .tabItem {
                    Label("Principal", systemImage: "house")
                }
            
            GalleryView()
                .tabItem {
                    Label("Galeria", systemImage: "circle.grid.3x3.fill")
                }
            
            FavView()
                .tabItem {
                    Label("Favoritos", systemImage: "star.fill")
                }
        }
        .alert("Spatial Shoes Error", isPresented: $vmBindable.showAlert, actions: {}) {
            Text(vmBindable.errorMsg)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView.preview
}
