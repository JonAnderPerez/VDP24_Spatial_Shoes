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
    
    @Binding var domeEntity: Entity?
    
    var body: some View {
        RealityView { content in
            do {
                // Tienda
                let storeScene = try await Entity(named: "Store", in: shoesBundle)
                storeScene.position = [-0.1, 0, -1.1]
                content.add(storeScene)
                
                // Ambiente espacial
                let resourceName = "Moon"
                let resource = try await TextureResource(named: resourceName)
                var material = UnlitMaterial()
                material.color = .init(texture: .init(resource))
                
                if domeEntity == nil {
                    domeEntity = Entity()
                }
                
                domeEntity!.components.set(ModelComponent(mesh: .generateSphere(radius: 1000), materials: [material]))
                domeEntity!.scale *= [-1, 1, 1]
                domeEntity!.transform.rotation = simd_quatf(angle: -2, axis: [0, 1, 0])
                content.add(domeEntity!)
                
                do {
                    try await domeEntity!.components.set(ImageBasedLightComponent(source: .single(.init(named: "Directional\(resourceName)")), intensityExponent: 1.5))
                    storeScene.components.set(ImageBasedLightReceiverComponent(imageBasedLight: domeEntity!))
                } catch {
                    print("EnvironmentResource error: \(error)")
                }
            } catch {
                print("Error en la carga \(error)")
            }
        }
        .onDisappear {
            domeEntity = nil
        }
    }
}
