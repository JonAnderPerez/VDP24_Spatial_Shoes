//
//  ShowRoomView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 28/8/24.
//

import SwiftUI
import RealityKit
import Shoes

struct ShowRoomView: View {
    @Environment(ShoesViewModel.self) private var vm
    @Environment(\.dismissWindow) private var dismiss
    @Environment(\.openWindow) private var open
    @Environment(\.openImmersiveSpace) private var openSpace
    
    let handAnchor = AnchorEntity(.head, trackingMode: .once)
    
    @State private var parentEntity: Entity?
    
    var body: some View {
        ZStack {
            StoreView() // Para poder usar el espacio immersivo en Vision 1.2
            
            RealityView { content in
                do {
                    if let selectedShoe = vm.selectedShoe {
                        let shoeEntity = try await Entity(named: selectedShoe.model3DName, in: shoesBundle)
                        
                        parentEntity = Entity()
                        parentEntity!.addChild(shoeEntity)
                        
                        //Anadimos la zapatilla a la escena
                        parentEntity!.setParent(handAnchor)
                        parentEntity!.position = [0, -0.15, -0.6]
                        
                        //Modificamos la zapatilla
                        vm.modifyImmersiveShoeScaleAndPosition(shoeEntity)
                    }
                    
                    content.add(handAnchor)
                } catch {
                    print("Error al cargar las zapatillas: \(error)")
                }
            } update: { content in
                if let selectedShoe = vm.selectedShoe, let childEntity = parentEntity?.children.first {
                    parentEntity?.removeChild(childEntity)
                    
                    Task {
                        do {
                            let shoeEntity = try await Entity(named: selectedShoe.model3DName, in: shoesBundle)
                            
                            parentEntity!.addChild(shoeEntity)
                            
                            //Modificamos la zapatilla
                            vm.modifyImmersiveShoeScaleAndPosition(shoeEntity)
                        } catch {
                            print("Error al cargar las zapatillas: \(error)")
                        }
                    }
                }
            }.installGestures()
        }
        .onAppear {
            dismiss(id: "MainContent")
            dismiss(id: "ShoeDetail3D")
            open(id: "HomeScrollView")
        }
        .onDisappear {
            open(id: "MainContent")
        }
        
        /* Para Vision 2.0
         .immersiveEnvironmentPicker {
             Button {
                 Task {
                     await openSpace(id: "Store")
                 }
             } label: {
                 Label("Spatial Shoes Store", systemImage: "house")
             }
         }
         */
    }
}

#Preview {
    ShowRoomView()
}
