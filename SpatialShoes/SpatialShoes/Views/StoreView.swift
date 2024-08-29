//
//  StoreView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 28/8/24.
//

import SwiftUI
import RealityKit
import Shoes

struct StoreView: View {
    var body: some View {
        RealityView { content in
            do {
                // Tienda
                let scene = try await Entity(named: "Store", in: shoesBundle)
                scene.position = [-0.1, 0, -1.1]
                content.add(scene)
                
                // Ambiente espacial
                let resource = try await TextureResource(named: "Starfield")
                var material = UnlitMaterial()
                material.color = .init(texture: .init(resource))
                let entity = Entity()
                entity.components.set(ModelComponent(mesh: .generateSphere(radius: 1000), materials: [material]))
                entity.scale *= [-1, 1, 1]
                content.add(entity)
            } catch {
                print("Error en la carga \(error)")
            }
        }
    }
}
