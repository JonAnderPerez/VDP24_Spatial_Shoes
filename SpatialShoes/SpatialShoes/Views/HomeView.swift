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
    @Environment(\.openWindow) private var open
    @Environment(\.dismissWindow) private var dismiss
    
    @State private var parentEntity: Entity?
    
    var body: some View {
        @Bindable var vmBindable = vm
        NavigationStack {
            VStack {
                HStack(alignment: .center) {
                    if let selectedShoe = vm.selectedShoe {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(selectedShoe.name)
                                .font(.extraLargeTitle)
                            
                            Text(LocalizedStringKey(selectedShoe.description))
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            
                            Text("\(selectedShoe.price.formatted(.number))€")
                                .font(.largeTitle)
                                .foregroundStyle(.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(Color(.yellow)))
                            
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Spacer().frame(width: 32)
                                    
                                    ForEach(selectedShoe.colors.dropFirst(), id: \.self) { shoeColor in
                                        Circle()
                                            .frame(width: 32, height: 32)
                                            .padding(.trailing, 8)
                                            .foregroundStyle(vm.getColor(shoeColor))
                                    }
                                    
                                    Spacer()
                                }.offset(x: 0, y: -16)
                                Spacer()
                            }
                            .frame(width: 350, height: 96)
                            .background(RoundedRectangle(cornerRadius: 100, style: .circular).foregroundStyle(vm.getColor(selectedShoe.colors.first ?? .white)))
                            .padding(.top)
                            
                            NavigationLink(value: selectedShoe) {
                                Label("Info", systemImage: "plus")
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
                                
                                if vm.rotate {
                                    //Anadimos la rotacion
                                    vm.rotateUniqueShoe(parentEntity!, rotate: vm.rotate)
                                }
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
            .navigationDestination(for: Shoe.self) { shoe in
                 DetailView(selectedShoe: shoe)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Toggle("Rotación 3D", systemImage: "rotate.3d", isOn: $vmBindable.rotate)
                }
            }
            .onChange(of: vm.rotate) {
                //Anadimos la rotacion
                vm.rotateUniqueShoe(parentEntity!, rotate: vm.rotate)
            }
            .onAppear {
                open(id: "ShoesScrollView")
            }
            .onDisappear {
                dismiss(id: "ShoesScrollView")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    HomeView.preview
}
