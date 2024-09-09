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
    @Environment(\.openImmersiveSpace) private var openSpace
    
    private let gridItem: [GridItem] = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItem) {
                    ForEach(vm.shoes, id: \.id) { shoe in
                        ShoeCard(
                            shoe: shoe,
                            isNavigationCard: true,
                            rotate: false,
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
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    Button {
                        Task {
                            await openSpace(id: "ImmersiveShowRoom")
                        }
                    } label: {
                        Label("Carrousel immersivo", systemImage: "square.stack.3d.down.forward.fill")
                    }
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    GalleryView.preview
}
