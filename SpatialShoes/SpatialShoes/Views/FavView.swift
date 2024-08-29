//
//  FavView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import SwiftUI
import RealityKit
import Shoes

struct FavView: View {
    @Environment(ShoesViewModel.self) private var vm
    
    private let gridItem: [GridItem] = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItem) {
                    ForEach(vm.shoes.filter({ $0.isFav })) { shoe in
                        ShoeCard(shoe: shoe, isNavigationCard: true, rotate: true, isFav: shoe.isFav)
                    }
                }
            }
            .safeAreaPadding(.vertical, 32)
            .safeAreaPadding(.horizontal)
            .scrollIndicators(.never)
            .navigationTitle("Spatial Shoes")
            .navigationDestination(for: Shoe.self) { shoe in
                 DetailView(selectedShoe: shoe)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    FavView.preview
}
