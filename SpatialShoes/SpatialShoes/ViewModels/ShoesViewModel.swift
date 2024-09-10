//
//  ShoesViewModel.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 16/8/24.
//

import SwiftUI
import RealityKit
import Combine

@Observable
final class ShoesViewModel {

    // General
    let interactor: DataInteractor
    let rotationManager: RotationManager
    
    // Zapatillas
    var selectedShoe: Shoe?
    
    private var favShoesIndex: [FavShoe]
    
    private let privShoes: [Shoe]
    
    // Zapatillas marcadas como favoritas
    var shoes: [Shoe] {
        privShoes.map { shoe in
            var newShoe = shoe
            newShoe.isFav = favShoesIndex.contains(where: { $0.id == shoe.id })
            return newShoe
        }
    }
    
    // Dome - Entidad desde la que se añade la luz mediante IBL a las zapatillas en las escena
    var domeEntity: Entity?
    
    // Rotacion
    var rotate = false
    @ObservationIgnored private var rotationTimers: [Cancellable] = []
    
    // Alerta
    @ObservationIgnored var errorMsg = ""
    var showAlert = false
    
    init(interactor: DataInteractor = Interactor()) {
        GestureComponent.registerComponent() // Registro del componente para la gestion de gestos en la zapatilla
        
        self.rotationManager = RotationManager()
        
        self.interactor = interactor
        self.favShoesIndex = []
        do {
            self.privShoes = try interactor.getShoes()
            self.selectedShoe = shoes.randomElement()
        } catch {
            self.privShoes = []
            
            print("Error en la carga del JSON de zapatillas: \(error)")
            errorMsg = "Error en la carga del JSON de zapatillas: \(error)"
            showAlert.toggle()
        }
        
        Task {
            // Cargamos las zapatillas favoritas al inicio
            await fetchFavShoes()
        }
    }

    // Shoe funciones
    func getColor(_ shoeColor: ShoeColor) -> Color {
        switch shoeColor {
            case .black:
                return .black
            case .brown:
                return .brown
            case .red:
                return .red
            case .white:
                return .white
        }
    }
    
    // Fav funciones
    @MainActor func toggleFavShoe(id: Int, isFav: Bool) {
        if !isFav {
            removeShoeFromFav(id: id)
        } else {
            addShoeToFav(id: id)
        }
        fetchFavShoes()
        
        if selectedShoe?.id == id {
            selectedShoe = shoes.first(where: { $0.id == id })
        }
    }
    
    @MainActor func addShoeToFav(id: Int) {
        do {
            try FavShoeInteractor.shared.appendFav(item: FavShoe(id: id))
        } catch {
            print("Error al guardar la zapatilla \(id) en favoritos: \(error)")
            errorMsg = "Error al guardar la zapatilla \(id) en favoritos: \(error)"
            showAlert.toggle()
        }
    }
    
    @MainActor func removeShoeFromFav(id: Int) {
        do {
            guard let favShoe = self.favShoesIndex.first(where: { $0.id == id }) else {
                return
            }
            try FavShoeInteractor.shared.removeFav(favShoe)
        } catch {
            print("Error al eliminar la zapatilla \(id) en favoritos: \(error)")
            errorMsg = "Error al eliminar la zapatilla \(id) en favoritos: \(error)"
            showAlert.toggle()
        }
    }
    
    @MainActor private func fetchFavShoes() {
        do {
            self.favShoesIndex = try FavShoeInteractor.shared.fetchFav()
        } catch {
            self.favShoesIndex = []
            
            print("Error al recuperar las zapatillas en favoritos: \(error)")
            errorMsg = "Error al recuperar las zapatillas en favoritos: \(error)"
            showAlert.toggle()
        }
    }
    
    // 3D Model functions
    @MainActor func modifySmallShoeScaleAndPosition(_ shoeEntity: Entity) {
        shoeEntity.scale *= 0.0025
        shoeEntity.position = [0, -0.03, 0]
        
        modifyRotation(shoeEntity)
    }
    
    @MainActor func modifyBigShoeScaleAndPosition(_ shoeEntity: Entity) {
        shoeEntity.scale *= 0.005
        shoeEntity.position = [0, -0.03, 0]
        
        modifyRotation(shoeEntity)
    }
    
    @MainActor private func modifyRotation(_ shoeEntity: Entity) {
        // Rotación en el eje X
        let rotationX = simd_quatf(angle: -45 * .pi / 180, axis: [1, 0, 0])

        // Combinación de las rotaciones
        shoeEntity.transform.rotation = rotationX
    }
    
    @MainActor func modifyVolumetricShoeScaleAndPosition(_ shoeEntity: Entity) {
        shoeEntity.scale *= 0.008
        shoeEntity.position = [0, -0.2, 0.15]
        
        // Info: Con las colisiones generadas por shoeEntity.generateCollisionShapes(recursive: true) no interactua con InputTargetComponent, ni con las colisiones generadas desde RCP
        shoeEntity.components.set(CollisionComponent(shapes: [.generateBox(width: 30, height: 60, depth: 30)
                                                                    .offsetBy(translation: [0, 0, 15])]))
        shoeEntity.components.set(InputTargetComponent())
        
        // Aniadidos los gestos al modelo
        let gestureComponent = GestureComponent()
        shoeEntity.components.set(gestureComponent)
    }
    
    @MainActor func modifyImmersiveShoeScaleAndPosition(_ shoeEntity: Entity) {
        shoeEntity.scale *= 0.005
        shoeEntity.position = [0, -0.03, 0]
        
        // Info: Con las colisiones generadas por shoeEntity.generateCollisionShapes(recursive: true) no interactua con InputTargetComponent, ni con las colisiones generadas desde RCP
        shoeEntity.components.set(CollisionComponent(shapes: [.generateBox(width: 30, height: 60, depth: 30)
                                                                    .offsetBy(translation: [0, 0, 15])]))
        shoeEntity.components.set(InputTargetComponent())
        
        // Aniadidos los gestos al modelo
        let gestureComponent = GestureComponent(resetOnEnded: true)
        shoeEntity.components.set(gestureComponent)
    }

    // Rotacion Modelo 3D
    func startRotation() {
        rotationManager.startRotation()
    }
    
    func rotateShoe(_ shoeEntity: Entity, rotate: Bool = true) {
        if rotate {
            rotationManager.startRotation()
            rotationManager.registerEntity(shoeEntity)
        } else {
            rotationManager.unregisterEntity(shoeEntity)
        }
    }
    
    func rotateUniqueShoe(_ shoeEntity: Entity, rotate: Bool = true) {
        rotationManager.rotateUniqueShoe(shoeEntity, rotate: rotate)
    }
}
