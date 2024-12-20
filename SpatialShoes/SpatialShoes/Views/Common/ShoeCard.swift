//
//  ShoeCard.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 21/8/24.
//

import SwiftUI
import RealityKit
import Shoes

struct ShoeCard: View {
    @Environment(ShoesViewModel.self) private var vm
    
    let shoe: Shoe
    let isNavigationCard: Bool
    
    @State var rotate: Bool = false
    @Binding var isFav: Bool
    
    var body: some View {
        ZStack {
            //Stack para darle el efecto de hover unicamente al background
            if isNavigationCard {
                NavigationLink(value: shoe) {
                    Spacer()
                        .frame(width: 300, height: 380)
                        .glassBackgroundEffect()
                }
                .buttonStyle(.plain)
                .buttonBorderShape(.roundedRectangle(radius: 42))
            } else {
                Button {
                    vm.selectedShoe = shoe
                } label: {
                    Spacer()
                        .frame(width: 300, height: 380)
                        .glassBackgroundEffect()
                }
                .buttonStyle(.plain)
                .buttonBorderShape(.roundedRectangle(radius: 42))
            }
            
            VStack {
                RealityView { content in
                    do {
                        let shoeEntity = try await Entity(named: shoe.model3DName, in: shoesBundle)
                        
                        if let domeEntity = vm.domeEntity {
                            shoeEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: domeEntity))
                        }
                        
                        let parentEntity = Entity()
                        parentEntity.addChild(shoeEntity)
                        
                        //Anadimos la zapatilla a la escena
                        content.add(parentEntity)
                        
                        //Modificamos la zapatilla
                        vm.modifySmallShoeScaleAndPosition(shoeEntity)
                    } catch {
                        print("Error al cargar las zapatillas en el card \(shoe.model3DName): \(error)")
                    }
                } update: { content in
                    if let parentEntity = content.entities.first {
                        if rotate {
                            //Anadimos la rotacion
                            vm.rotateShoe(parentEntity)
                        }
                        
                        if let domeEntity = vm.domeEntity, let shoeEntity = parentEntity.children.first {
                            shoeEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: domeEntity))
                        }
                    }
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
                    
                    Toggle("Favorito", systemImage: "star", isOn: $isFav)
                        .toggleStyle(.button)
                        .buttonBorderShape(.circle)
                        .labelStyle(.iconOnly)
                        .padding()
                }
            }
        }
        .frame(width: 300)
    }
}

#Preview(windowStyle: .automatic) {
    NavigationStack {
        ShoeCard.preview
    }
}
