//
//  ShoesViewModel.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import SwiftUI
import RealityKit
import Combine

@Observable
final class ShoesViewModel {
    let interactor: DataInteractor
    
    var shoes: [Shoe]
    var selectedShoe: Shoe?
    
    var showingPlanets = false
    var showingImmersive = false
    
    @ObservationIgnored var errorMsg = ""
    var showAlert = false
    
    @ObservationIgnored private var rotationTimers: [Cancellable] = []
    
    init(interactor: DataInteractor = Interactor()) {
        self.interactor = interactor
        do {
            self.shoes = try interactor.getShoes()
            self.selectedShoe = shoes.randomElement()
        } catch {
            self.shoes = []
            errorMsg = "Error en la carga del JSON de zapatillas: \(error)"
            showAlert.toggle()
        }
    }
    
    func selectRandom() {
        selectedShoe = shoes.randomElement()
    }
    
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
    
    @MainActor func modifySmallShoeScaleAndPosition(_ shoeEntity: Entity) {
        shoeEntity.scale *= 0.0025
        shoeEntity.position = [0, -0.03, 0]
        
        // Rotación en el eje X
        let rotationX = simd_quatf(angle: -45 * .pi / 180, axis: [1, 0, 0])
        // Rotación en el eje Y
        //let rotationY = simd_quatf(angle: -35 * .pi / 180, axis: [0, 1, 0])

        // Combinación de las rotaciones
        shoeEntity.transform.rotation = rotationX //* rotationY
    }
    
    @MainActor func modifyBigShoeScaleAndPosition(_ shoeEntity: Entity) {
        shoeEntity.scale *= 0.005
        shoeEntity.position = [0, -0.03, 0]
        
        // Rotación en el eje X
        let rotationX = simd_quatf(angle: -45 * .pi / 180, axis: [1, 0, 0])
        // Rotación en el eje Y
        //let rotationY = simd_quatf(angle: -45 * .pi / 180, axis: [0, 1, 0])

        // Combinación de las rotaciones
        shoeEntity.transform.rotation = rotationX //* rotationY
    }

    func rotateShoe(_ shoeEntity: Entity, rotate: Bool = true) {
        
        if !rotate {
            rotationTimers.removeAll()
            return
        }
        
        let rotationInterval: TimeInterval = 10.0 // Duración de una rotación completa en segundos
        let degreesPerSecond = 360.0 / rotationInterval // Grados por segundo
        let timerInterval: TimeInterval = 0.03 // Intervalo del timer en segundos
        let degreesPerTick = Float(degreesPerSecond * timerInterval) // Grados por cada tick del timer

        var currentRotation: Float = 0.0
        
        // Almacenar la rotación inicial
        let initialRotation = shoeEntity.transform.rotation

        let timer = Timer.publish(every: timerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                currentRotation += degreesPerTick

                // Reiniciar el ángulo si supera los 360 grados
                if currentRotation >= 360 {
                    currentRotation -= 360
                }

                // Crear la rotación incremental alrededor del eje Y
                let incrementalRotation = simd_quatf(angle: currentRotation * .pi / 180, axis: [0, 1, 0])

                // Aplicar la rotación incremental sobre la rotación inicial
                shoeEntity.transform.rotation = initialRotation * incrementalRotation
            }
        
        rotationTimers.append(timer) // Asumiendo que `rotationTimers` es un array para almacenar los timers
    }

}