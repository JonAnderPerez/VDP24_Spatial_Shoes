//
//  HomeView.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 16/8/24.
//

import SwiftUI
import RealityKit
import Shoes

struct HomeView: View {
    @Environment(ShoesViewModel.self) private var vm
    @Environment(\.openWindow) private var open
    @Environment(\.dismissWindow) private var dismiss
    
    var body: some View {
        @Bindable var vmBindable = vm
        NavigationStack {
            HStack(alignment: .center) {
                if let selectedShoe = vm.selectedShoe {
                    // Informacion basica
                    shoeInfo(selectedShoe)
                    
                    Spacer()
                    
                    // Modelo 3D en grande
                    ShoeBigModel(selectedShoe: selectedShoe, isHomeView: true)
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
            .onAppear {
                open(id: "ShoesScrollView")
            }
            .onDisappear {
                dismiss(id: "ShoesScrollView")
            }
        }
    }
    
    private func shoeInfo(_ selectedShoe: Shoe) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Titulo
            Text(selectedShoe.name)
                .font(.extraLargeTitle)
            
            // Descripción
            Text(LocalizedStringKey(selectedShoe.description))
                .font(.title2)
                .foregroundStyle(.secondary)
            
            // Precio
            Text("\(selectedShoe.price.formatted(.number))€")
                .font(.largeTitle)
                .foregroundStyle(.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(Color(.yellow)))
            
            // Stack de colores
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
            
            // Boton de Info para ir al detalle
            NavigationLink(value: selectedShoe) {
                Label("Info", systemImage: "plus")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    HomeView.preview
}
