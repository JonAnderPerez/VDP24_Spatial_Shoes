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
    @Environment(\.dismissImmersiveSpace) private var dismissSpace
    
    let handAnchor = AnchorEntity(.head, trackingMode: .once)
    
    //@State private var parentEntity: Entity?
    
    var body: some View {
        ZStack {
            StoreView() // Para poder usar el espacio immersivo en Vision 1.2
            
            RealityView { content, attachments in
                do {
                    if let selectedShoe = vm.selectedShoe {
                        let shoeEntity = try await Entity(named: selectedShoe.model3DName, in: shoesBundle)
                        shoeEntity.name = "ShoeChild"
                        
                        let parentEntity = Entity()
                        parentEntity.name = "ParentEntity"
                        parentEntity.addChild(shoeEntity)
                        
                        //Anadimos la zapatilla a la escena
                        parentEntity.setParent(handAnchor)
                        parentEntity.position = [0, -0.15, -0.6]
                        
                        //Modificamos la zapatilla
                        vm.modifyImmersiveShoeScaleAndPosition(shoeEntity)
                        
                        if let dismissButton = attachments.entity(for: "dismissButton") {
                            parentEntity.addChild(dismissButton)
                            dismissButton.position = [0, -0.15, 0];
                        }
                    }
                    
                    content.add(handAnchor)
                } catch {
                    print("Error al cargar las zapatillas: \(error)")
                }
            } update: { content, _ in
                if let selectedShoe = vm.selectedShoe,
                    let anchor = content.entities.first,
                    let parentEntity = anchor.findEntity(named: "ParentEntity"),
                    let childEntity = parentEntity.findEntity(named: "ShoeChild") {
                    parentEntity.removeChild(childEntity)
                    
                    Task {
                        do {
                            let shoeEntity = try await Entity(named: selectedShoe.model3DName, in: shoesBundle)
                            shoeEntity.name = "ShoeChild"
                            
                            parentEntity.addChild(shoeEntity)
                            
                            //Modificamos la zapatilla
                            vm.modifyImmersiveShoeScaleAndPosition(shoeEntity)
                        } catch {
                            print("Error al cargar las zapatillas: \(error)")
                        }
                    }
                }
            } attachments: {
                Attachment(id: "dismissButton") {
                    Button("Cerrar carrusel immersivo", systemImage: "xmark") {
                        Task {
                            dismiss(id: "ShoesScrollView")
                            await dismissSpace()
                        }
                    }
                    .buttonBorderShape(.circle)
                    .labelStyle(.iconOnly)
                }
            }
            .installGestures()
        }
        .onAppear {
            dismiss(id: "MainContent")
            dismiss(id: "ShoeDetail3D")
            open(id: "ShoesScrollView")
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