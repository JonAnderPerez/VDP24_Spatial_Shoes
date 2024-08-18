//
//  HomeView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import SwiftUI
import RealityKit
import Shoes

struct HomeView: View {
    @Environment(ShoesViewModel.self) private var vm
    
    @State private var rotate = false
    @State private var parentEntity: Entity?
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    if let selectedShoe = vm.selectedShoe {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(selectedShoe.name)
                                    .font(.extraLargeTitle)
                                
                                Button("Favorito", systemImage: "star") {
                                    
                                }
                                .labelStyle(.iconOnly)
                            }
                            
                            Text(selectedShoe.description)
                                .lineLimit(4)
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            
                            Text("\(selectedShoe.price.formatted(.number))€")
                                .font(.largeTitle)
                                .foregroundStyle(.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(Color(.yellow)))
                            
                            HStack(alignment: .top) {
                                Spacer().frame(width: 32)
                                
                                ForEach(selectedShoe.colors.dropFirst(), id: \.self) { shoeColor in
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .offset(x: 0, y: -16)
                                        .padding(.trailing, 8)
                                        .foregroundStyle(vm.getColor(shoeColor))
                                }

                                Spacer().frame(width: 350, height: 96)
                            }
                            .background(RoundedRectangle(cornerRadius: 100, style: .circular).foregroundStyle(vm.getColor(selectedShoe.colors.first ?? .white)))
                            .padding(.top)
                            
                            Button("Info", systemImage: "plus") {
                                vm.selectRandom()
                            }
                        }
                        
                        Spacer()
                        
                        RealityView { content in
                            do {
                                let shoeEntity = try await Entity(named: selectedShoe.model3DName, in: shoesBundle)
                                
                                parentEntity = Entity()
                                parentEntity!.addChild(shoeEntity)
                                
                                //Anadimos la zapatilla a la escena
                                content.add(parentEntity!)
                                
                                //Modificamos la zapatilla
                                vm.modifyBigShoeScaleAndPosition(shoeEntity)
                            } catch {
                                print("Error al cargar las zapatillas: \(error)")
                            }
                        } update: { _ in
                            if let selectedShoe = vm.selectedShoe, let childEntity = parentEntity?.children.first {
                                parentEntity?.removeChild(childEntity)
                                
                                Task {
                                    do {
                                        let shoeEntity = try await Entity(named: selectedShoe.model3DName, in: shoesBundle)
                                        
                                        parentEntity!.addChild(shoeEntity)
                                        
                                        //Modificamos la zapatilla
                                        vm.modifyBigShoeScaleAndPosition(shoeEntity)
                                    } catch {
                                        print("Error al cargar las zapatillas: \(error)")
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(width: 400, height: 400)
                        .frame(depth: 400, alignment: .back)
                    }
                }
            }
            .padding(32)
            .navigationTitle("Spatial Shoes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Toggle("Rotación 3D", systemImage: "rotate.3d", isOn: $rotate)
                }
                ToolbarItem(placement: .bottomOrnament) {
                    Button {
                        
                    } label: {
                        Label("Carrousel immersivo", systemImage: "square.stack.3d.down.forward.fill")
                    }
                }
            }
            .onChange(of: rotate) { _, _ in
                //Anadimos la rotacion
                vm.rotateShoe(parentEntity!, rotate: rotate)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    HomeView.preview
}
