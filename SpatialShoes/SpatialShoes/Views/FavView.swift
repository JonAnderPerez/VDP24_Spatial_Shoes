//
//  FavView.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 16/8/24.
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
                        ShoeCard(
                            shoe: shoe,
                            isNavigationCard: true,
                            rotate: true,
                            isFav: .init(
                                get: { shoe.isFav },
                                set: { newVal in vm.toggleFavShoe(id: shoe.id, isFav: newVal) }
                            )
                        )
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
            .onAppear {
                vm.startRotation()
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    FavView.preview
}
