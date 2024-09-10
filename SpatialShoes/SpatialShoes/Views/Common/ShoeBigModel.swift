//
//  ShoeBigModel.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 9/9/24.
//

import SwiftUI
import RealityKit
import Shoes

struct ShoeBigModel: View {
    @Environment(ShoesViewModel.self) private var vm
    
    @State var selectedShoe: Shoe
    
    @State private var parentEntity: Entity?
    @State private var modelName = ""
    
    var isHomeView = false
    
    
    var body: some View {
        RealityView { content in
            do {
                let shoeEntity = try await Entity(named: selectedShoe.model3DName, in: shoesBundle)
                shoeEntity.name = selectedShoe.model3DName
                modelName = selectedShoe.model3DName
                
                parentEntity = Entity()
                parentEntity!.addChild(shoeEntity)
                
                //Anadimos la zapatilla a la escena
                content.add(parentEntity!)
                
                //Modificamos la zapatilla
                vm.modifyBigShoeScaleAndPosition(shoeEntity)
                
                //Anadimos la rotacion
                vm.rotateUniqueShoe(parentEntity!, rotate: vm.rotate)
            } catch {
                print("Error al cargar las zapatillas: \(error)")
            }
        } update: { content in
            if let parentEntity = parentEntity {
                //Anadimos la rotacion
                vm.rotateUniqueShoe(parentEntity, rotate: vm.rotate)
                
                var selectedShoe = self.selectedShoe
                if isHomeView, vm.selectedShoe != nil {
                    selectedShoe = vm.selectedShoe!
                }

                if let childEntity = parentEntity.findEntity(named: self.modelName),
                   selectedShoe.model3DName != childEntity.name {
                    childEntity.removeFromParent()
                         
                    Task {
                        do {
                            self.modelName = selectedShoe.model3DName
                            
                            let shoeEntity = try await Entity(named: selectedShoe.model3DName, in: shoesBundle)
                            
                            parentEntity.addChild(shoeEntity)
                            
                            //Modificamos la zapatilla
                            vm.modifyBigShoeScaleAndPosition(shoeEntity)
                        } catch {
                            print("Error al cargar las zapatillas: \(error)")
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: 400, height: 400)
        .frame(depth: 400, alignment: .back)
        .onChange(of: vm.rotate) {
            if let parentEntity = parentEntity {
                vm.rotateUniqueShoe(parentEntity, rotate: vm.rotate)
            }
        }
    }
}

#Preview {
    ShoeBigModel.preview
}
