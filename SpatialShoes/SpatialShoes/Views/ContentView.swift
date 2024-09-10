//
//  ContentView.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 16/8/24.
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
        .frame(width: 1280 , height: 720) // Tamaño fijo para las pantallas
        .alert("Error Spatial Shoes", isPresented: $vmBindable.showAlert, actions: {}) {
            Text(vmBindable.errorMsg)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView.preview
}
