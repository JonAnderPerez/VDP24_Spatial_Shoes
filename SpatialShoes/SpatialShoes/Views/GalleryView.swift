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
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    
    private let gridItem: [GridItem] = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar content
            List {
                
            }
            .navigationTitle("Filtros")
        } detail: {
            ScrollView {
                LazyVGrid(columns: gridItem) {
                    ForEach(vm.shoes) { shoe in
                        NavigationLink(value: shoe) {
                            ShoeCard(shoe: shoe)
                                .glassBackgroundEffect()
                        }
                        .buttonStyle(.plain)
                        .buttonBorderShape(.roundedRectangle(radius: 42))
                    }
                }
            }
            .safeAreaPadding(.vertical, 32)
            .safeAreaPadding(.horizontal)
            .scrollIndicators(.never)
            .navigationSplitViewStyle(.balanced)
            .navigationTitle("Spatial Shoes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Filtros", systemImage: "line.3.horizontal.decrease") {
                        if columnVisibility == .all {
                            columnVisibility = .detailOnly
                        } else {
                            columnVisibility = .all
                        }
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
