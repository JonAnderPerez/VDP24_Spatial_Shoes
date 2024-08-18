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
                        VStack {
                            RealityView { content in
                                do {
                                    let shoeEntity = try await Entity(named: shoe.model3DName, in: shoesBundle)
                                    
                                    let parentEntity = Entity()
                                    parentEntity.addChild(shoeEntity)
                                    
                                    //Anadimos la zapatilla a la escena
                                    content.add(parentEntity)
                                    
                                    //Modificamos la zapatilla
                                    vm.modifySmallShoeScaleAndPosition(shoeEntity)
                                } catch {
                                    print("Error al cargar las zapatillas: \(error)")
                                }
                            } update: { _ in
                                
                            }
                            .padding()
                            .frame(width: 250, height: 250)
                            .frame(depth: 250, alignment: .back)
                            
                            HStack(alignment: .center) {
                                Text(shoe.name)
                                    .font(.title)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2, reservesSpace: true)
                                    .padding()
                                
                                Button("Favorito", systemImage: "star") {
                                    
                                }
                                .labelStyle(.iconOnly)
                                .padding()
                            }
                        }
                        .frame(width: 300)
                        .glassBackgroundEffect()
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
        }
    }
}

#Preview(windowStyle: .automatic) {
    GalleryView.preview
}
