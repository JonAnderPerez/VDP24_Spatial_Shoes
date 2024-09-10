//
//  DetailView.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 16/8/24.
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
    
    @State private var isFav: Bool
    
    init(selectedShoe: Shoe) {
        self.selectedShoe = selectedShoe
        _isFav = State(initialValue: selectedShoe.isFav)
    }
    
    var body: some View {
        @Bindable var vmBindable = vm
        HStack {
            shoeDetailScroll()

            Spacer()
            
            ShoeBigModel(selectedShoe: selectedShoe)
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
        .onChange(of: isFav) {
            vm.toggleFavShoe(id: selectedShoe.id, isFav: isFav)
        }
        .onDisappear {
            dismissWindow(id: "ShoeDetail3D")
            dismiss()
        }
    }
    
    private func shoeDetailScroll() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                // Nombre zapatilla
                Text(selectedShoe.name)
                    .font(.extraLargeTitle)
                
                // Boton de favorito
                Toggle("Favorito", systemImage: "star", isOn: $isFav)
                    .toggleStyle(.button)
                    .buttonBorderShape(.circle)
                    .labelStyle(.iconOnly)
                    .padding()
            }
            
            // Precio
            Text("\(selectedShoe.price.formatted(.number))€")
                .font(.largeTitle)
                .foregroundStyle(.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(Color(.yellow)))
            
            // Detalles
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
    }
    
    private func detailItem(type: String, value: String) -> some View {
        HStack {
            Text(type)
                .font(.title)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.largeTitle)
                .foregroundStyle(.primary)
        }
    }
    
    private func detailItemList(type: String, values: [String]) -> some View {
        HStack(alignment: .top) {
            Text(type)
                .font(.title)
                .foregroundStyle(.secondary)
                .padding(.top, 24)
            
            FlexibleTextView(data: values, spacing: 8)
        }
    }
    
    private func detailItemColor(type: String, values: [ShoeColor]) -> some View {
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
