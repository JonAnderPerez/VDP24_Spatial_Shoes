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
        ScrollView {
            LazyVGrid(columns: gridItem) {
                ForEach(vm.shoes) { shoe in
                    VStack {
                        //TODO: Con RealityView se pueden escalar bien los modelos manteniendo las proporciones, con Model3D no, pero en este caso seria lo suyo, mirarlo...
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
                        
                        HStack {
                            Text(shoe.name)
                                .font(.title)
                                .padding()
                            
                            Button("Favorito", systemImage: "star") {
                                
                            }
                            .labelStyle(.iconOnly)
                            .padding()
                        }
                    }
                    .frame(width: 300, height: 400)
                }
            }
        }
        .safeAreaPadding(.vertical, 32)
        .safeAreaPadding(.horizontal)
        .scrollIndicators(.never)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Filtro", systemImage: "line.3.horizontal.decrease") {
                    
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    NavigationStack {
        GalleryView.preview
    }
}
