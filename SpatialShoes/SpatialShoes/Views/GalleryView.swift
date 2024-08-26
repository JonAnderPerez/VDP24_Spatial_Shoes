//
//  GalleryView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import SwiftUI
import RealityKit
import Shoes

struct GalleryView: View {
    @Environment(ShoesViewModel.self) private var vm
    
    private let gridItem: [GridItem] = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItem) {
                    ForEach(vm.shoes) { shoe in
                        ShoeCard(shoe: shoe, isNavigationCard: true)
                    }
                }
            }
            .safeAreaPadding(.vertical, 32)
            .safeAreaPadding(.horizontal)
            .scrollIndicators(.never)
            .navigationTitle("Spatial Shoes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Filtros", systemImage: "line.3.horizontal.decrease") {

                    }
                }
                ToolbarItem(placement: .bottomOrnament) {
                    Button("Carrousel immersivo", systemImage: "square.stack.3d.down.forward.fill") {
                        
                    }
                }
            }
            .navigationDestination(for: Shoe.self) { shoe in
                 DetailView(selectedShoe: shoe)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    GalleryView.preview
}
