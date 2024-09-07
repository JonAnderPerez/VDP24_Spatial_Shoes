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
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedShoe: Shoe
    
    @State private var parentEntity: Entity?
    @State private var isFav: Bool
    
    init(selectedShoe: Shoe) {
        self.selectedShoe = selectedShoe
        _isFav = State(initialValue: selectedShoe.isFav)
    }
    
    var body: some View {
        @Bindable var vmBindable = vm
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(selectedShoe.name)
                        .font(.extraLargeTitle)
                    
                    Toggle("Favorito", systemImage: "star", isOn: $isFav)
                        .toggleStyle(.button)
                        .buttonBorderShape(.circle)
                        .labelStyle(.iconOnly)
                        .padding()
                }
                
                Text("\(selectedShoe.price.formatted(.number))€")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(Color(.yellow)))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStringKey(selectedShoe.description))
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
                .scrollIndicators(.visible)
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
                if let childEntity = parentEntity?.children.first {
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
        .padding(32)
        .navigationTitle("Spatial Shoes")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Toggle("Rotación 3D", systemImage: "rotate.3d", isOn: $vmBindable.rotate)
            }
            ToolbarItem(placement: .bottomOrnament) {
                Button {
                    openWindow(id:"ShoeDetail3D", value: selectedShoe)
                } label: {
                    Label("Ver en detalle", systemImage: "view.3d")
                }
            }
        }
        .onChange(of: vm.rotate) { _, _ in
            //Anadimos la rotacion
            vm.rotateUniqueShoe(parentEntity!, rotate: vm.rotate)
        }
        .onChange(of: isFav) { _, _ in
            vm.toggleFavShoe(id: selectedShoe.id, isFav: isFav)
        }
        .onDisappear {
            dismissWindow(id: "ShoeDetail3D")
            dismiss()
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
        HStack(alignment: .top) {
            Text(type)
                .font(.title)
                .foregroundStyle(.secondary)
                .padding(.top, 24)
            
            FlexibleTextView(data: values, spacing: 8)
        }
    }
    
    func detailItemColor(type: String, values: [ShoeColor]) -> some View {
        HStack {
            Text(type)
                .font(.title)
                .foregroundStyle(.secondary)
            
            FlexibleColorView(data: values, spacing: 8)
        }
    }
}

#Preview(windowStyle: .automatic) {
    NavigationStack {
        DetailView.preview
    }
}
