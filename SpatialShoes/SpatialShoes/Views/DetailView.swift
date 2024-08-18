//
//  DetailView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import SwiftUI
import RealityKit
import Shoes

struct DetailView: View {
    @Environment(ShoesViewModel.self) private var vm
    
    @State private var rotate = false
    @State private var parentEntity: Entity?
    
    var body: some View {
        HStack {
            if let selectedShoe = vm.selectedShoe {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(selectedShoe.name)
                                .font(.extraLargeTitle)
                            
                            Button("Favorito", systemImage: "star") {
                                
                            }
                            .labelStyle(.iconOnly)
                        }
                        
                        Text("\(selectedShoe.price.formatted(.number))€")
                            .font(.largeTitle)
                            .foregroundStyle(.black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(Color(.yellow)))
                        
                        Text(selectedShoe.description)
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        detailItem(type: "Marca:", value: selectedShoe.brand)
                        detailItem(type: "Tipo:", value: selectedShoe.type)
                        detailItem(type: "Genero:", value: selectedShoe.gender)
                        detailItem(type: "Peso:", value: "\(selectedShoe.weight) Kg")
                        detailItem(type: "Garantia:", value: "\(selectedShoe.warranty) Años")
                        detailItem(type: "Origen:", value: selectedShoe.origin)
                        detailItemColor(type: "Colores:", values: selectedShoe.colors)
                        detailItemList(type: "Tallas:", values: selectedShoe.size.map { "\($0)" })
                        detailItemList(type: "Materiales:", values: selectedShoe.materials)
                        detailItemList(type: "Certificaciónes:", values: selectedShoe.certifications)
                    }
                }
                .scrollIndicators(.never)
                
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
    
    func detailItem(type: String, value: String) -> some View {
        HStack {
            Text(type)
                .font(.title)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.largeTitle)
                .foregroundStyle(.primary)
        }
    }
    
    func detailItemList(type: String, values: [String]) -> some View {
        HStack {
            Text(type)
                .font(.title)
                .foregroundStyle(.secondary)
            
            ForEach(values, id: \.self) { value in
                Text(value)
                    .font(.largeTitle)
                    .foregroundStyle(.primary)
                    .padding()
                    .glassBackgroundEffect()
            }
        }
    }
    
    func detailItemColor(type: String, values: [ShoeColor]) -> some View {
        HStack {
            Text(type)
                .font(.title)
                .foregroundStyle(.secondary)
            
            ForEach(values, id: \.self) { shoeColor in
                Circle()
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 8)
                    .foregroundStyle(vm.getColor(shoeColor))
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    NavigationStack {
        DetailView.preview
    }
}
