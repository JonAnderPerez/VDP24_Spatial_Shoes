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
        NavigationStack {
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
            .navigationTitle("Spatial Shoes")
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    Button {
                        
                    } label: {
                        Label("Carrousel immersivo", systemImage: "square.stack.3d.down.forward.fill")
                    }
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView.preview
}
