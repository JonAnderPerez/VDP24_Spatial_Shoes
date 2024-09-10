//
//  RotationManager.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 7/9/24.
//

import Foundation
import Combine
import RealityKit

class RotationManager {
    
    private let rotationInterval: TimeInterval = 10.0 // Duración de una rotación completa en segundos
    private let timerInterval: TimeInterval = 0.03 // Intervalo del timer en segundos
    private let degreesPerSecond: Double // Grados por segundo
    private let degreesPerTick: Float // Grados por cada tick del timer
    private var initialRotation: simd_quatf?
    
    private var currentRotation: Float = 0.0
    private var isRotating: Bool = false
    
    private var rotationTimers: [AnyCancellable] = []
    private var entities: [Entity] = []
    private var uniqueEntities: [Entity] = []

    init() {
        self.degreesPerSecond = 360.0 / rotationInterval
        self.degreesPerTick = Float(degreesPerSecond * timerInterval)
    }
    
    func startRotation() {
        if !isRotating {
            isRotating = true
            // Iniciar el timer que actualizará la rotación para todas las entidades registradas
            let timer = Timer.publish(every: timerInterval, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    self?.updateRotation()
                }
            
            rotationTimers.append(timer)
        }
    }
    
    private func updateRotation() {
        // Unicamente actualizamos los timer si hay entidades
        guard !entities.isEmpty else {
            return
        }
        
        currentRotation += degreesPerTick

        // Reiniciar el ángulo si supera los 360 grados
        if currentRotation >= 360 {
            currentRotation -= 360
        }

        let incrementalRotation = simd_quatf(angle: currentRotation * .pi / 180, axis: [0, 1, 0])

        guard let initialRotation = self.initialRotation else {
            return
        }
        
        // Aplicar la rotación incremental a todas las entidades registradas
        for entity in entities {
            entity.transform.rotation = initialRotation * incrementalRotation
        }
    }
    
    func stopRotation() {
        isRotating = false
        initialRotation = nil
        rotationTimers.removeAll()
    }
    
    func registerEntity(_ entity: Entity) {
        // Almacenar la entidad en la lista de entidades registradas
        entities.append(entity)
        
        if initialRotation == nil {
            initialRotation = entity.transform.rotation
        }
    }
    
    func unregisterEntity(_ entity: Entity) {
        // Eliminar la entidad de la lista de entidades registradas
        if let index = entities.firstIndex(of: entity) {
            entities.remove(at: index)
        }
    }
    
    func rotateUniqueShoe(_ shoeEntity: Entity, rotate: Bool) {
        
        if !rotate {
            stopRotation()
            uniqueEntities.removeAll()
            return
        }
        
        if !uniqueEntities.contains(where: { $0 == shoeEntity }) {
            uniqueEntities.append(shoeEntity)
            
            var currentRotation: Float = 0.0
            
            // Almacenar la rotación inicial
            let initialRotation = shoeEntity.transform.rotation

            let timer = Timer.publish(every: timerInterval, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    currentRotation += self.degreesPerTick

                    // Reiniciar el ángulo si supera los 360 grados
                    if currentRotation >= 360 {
                        currentRotation -= 360
                    }

                    // Crear la rotación incremental alrededor del eje Y
                    let incrementalRotation = simd_quatf(angle: currentRotation * .pi / 180, axis: [0, 1, 0])

                    // Aplicar la rotación incremental sobre la rotación inicial
                    shoeEntity.transform.rotation = initialRotation * incrementalRotation
                }
            
            rotationTimers.append(timer)
        }
    }
}

