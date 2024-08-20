//
//  Detail3DView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 20/8/24.
//

import SwiftUI
import RealityKit
import Shoes

struct Detail3DView: View {
    @Environment(ShoesViewModel.self) private var vm
    
    @State var selectedShoe: Shoe
    
    var body: some View {
        RealityView { content in
            if let shoeEntity = try? await Entity(named: selectedShoe.model3DName, in: shoesBundle) {
                
                //Anadimos la zapatilla a la escena
                content.add(shoeEntity)
                
                //Modificamos la zapatilla
                vm.modifyVolumetricShoeScaleAndPosition(shoeEntity)
            }
        } update: { _ in
            
        }.installGestures()
    }
}

#Preview(windowStyle: .volumetric) {
    Detail3DView.preview
}
