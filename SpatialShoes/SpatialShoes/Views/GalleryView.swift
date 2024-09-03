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
    
    @State private var gShoes: [Shoe] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItem) {
                    ForEach(gShoes) { shoe in
                        ShoeCard(shoe: shoe, isNavigationCard: true, isFav: shoe.isFav)
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
            .onAppear {
                print("Gallery onAppear")
                gShoes = vm.shoes
            }
            .onDisappear {
                print("Gallery onDismiss")
                gShoes.removeAll() //TODO: HAY QUE MIRAR A VER POR QUE NO ACTUALIZA LA LISTA... ni borrando y volviendo a instanciarlo...
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    GalleryView.preview
}
