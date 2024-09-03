//
//  EntityGestureState.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 20/8/24.
//

import SwiftUI
import RealityKit

// MARK: - EntityGestureState
public class EntityGestureState {
    
    // La entidad que actualmente está siendo arrastrada si un gesto está en progreso.
    var targetedEntity: Entity?
    
    // MARK: - Arrastrar (Drag)
    
    // La posición inicial del arrastre.
    var dragStartPosition: SIMD3<Float> = .zero
    
    // Indica si la aplicación está actualmente manejando un gesto de arrastre.
    var isDragging = false
 
    // La orientación inicial de la entidad cuando comienza el arrastre.
    var initialOrientation: simd_quatf?
    
    // MARK: - Ampliar (Magnify)
    
    // El valor inicial de la escala.
    var startScale: SIMD3<Float> = .one
    
    // Indica si la aplicación está actualmente manejando un gesto de ampliación (escalado).
    var isScaling = false
    
    // MARK: - Rotación
    
    // El valor inicial de la rotación.
    var startOrientation = Rotation3D.identity
    
    // Indica si la aplicación está actualmente manejando un gesto de rotación.
    var isRotating = false
    
    // MARK: - Acceso Singleton
    
    // Recupera la instancia compartida (singleton) de `EntityGestureState`.
    static let shared = EntityGestureState()
}

// MARK: - RotationAxes
public struct RotationAxes: Codable {
    var x: Bool
    var y: Bool
    var z: Bool
}

// MARK: - GestureComponent

// Un componente que maneja la lógica de gestos para una entidad.
public struct GestureComponent: Component, Codable {
    
    // Un valor booleano que indica si un gesto puede arrastrar la entidad.
    public var canDrag: Bool = true
    
    // Rotar unicamente en los ejes seleccionados
    public var selectedAxes = RotationAxes(x: true, y: true, z: true)
    
    // Un valor booleano que indica si un gesto puede escalar la entidad.
    public var canScale: Bool = true
    
    // Un valor booleano que indica si un gesto puede rotar la entidad.
    public var canRotate: Bool = true
    
    // Un valor boolean que indica si el modelo volvera a su transformada original al soltar el modelo
    public var resetOnEnded: Bool = false //TODO: Animar la vuelta al modelo original
    
    // MARK: - Lógica de Arrastre (Drag)
    
    // Maneja las acciones de `.onChanged` para los gestos de arrastre.
    mutating func onChanged(value: EntityTargetValue<DragGesture.Value>) {
        // Verificar si se permite arrastrar la entidad.
        guard canDrag else { return }

        let state = EntityGestureState.shared
        
        // Actualizar la entidad en caso de cambio unicamente
        if state.targetedEntity != value.entity {
            state.targetedEntity = value.entity
            state.initialOrientation = value.entity.orientation(relativeTo: nil)
        }
        
        // Asegurarse de que hay una entidad seleccionada.
        guard let entity = state.targetedEntity else { fatalError("El gesto no contiene una entidad") }

        // Si no se está arrastrando, inicializar el estado de arrastre.
        if !state.isDragging {
            state.isDragging = true
            state.dragStartPosition = entity.scenePosition
            state.initialOrientation = .init(entity.orientation(relativeTo: nil))
        }

        // Convertir la traslación 3D al espacio de la escena.
        let translation3D = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)
        
        // Crear un vector de traslación a partir de la traslación 3D.
        // Se aplica la correccion de direccion ya que el modelo esta orientado hacia el eje Z
        // Aplicar las condiciones según los ejes seleccionados
        let translationVector = SIMD3<Float>(
            selectedAxes.y ? -Float(translation3D.y) : 0, // Si el eje Y está habilitado, usar el valor, si no, 0
            selectedAxes.z ? -Float(translation3D.z) : 0, // Si el eje Z está habilitado, usar el valor, si no, 0
            selectedAxes.x ? Float(translation3D.x) : 0   // Si el eje X está habilitado, usar el valor, si no, 0
        )
        
        // Determinar la magnitud de la traslación (que se utilizará como ángulo de rotación).
        let translationMagnitude = length(translationVector)
        
        // Normalizar el vector de traslación para obtener el eje de rotación.
        let rotationAxis = normalize(translationVector)
        
        // Convertir la magnitud de la traslación en un ángulo de rotación (en radianes).
        let rotationAngle = translationMagnitude * 5 // Factor de escala para controlar la sensibilidad.
        
        // Crear un quaternion de rotación a partir del eje y el ángulo de rotación.
        let rotationQuaternion = simd_quatf(angle: rotationAngle, axis: rotationAxis)
        
        // Aplicar la rotación a la entidad.
        if let initialOrientation = state.initialOrientation {
            let newOrientation = initialOrientation * rotationQuaternion
            entity.setOrientation(newOrientation, relativeTo: nil)
        }
    }
    
    // Maneja las acciones de `.onEnded` para los gestos de arrastre.
    mutating func onEnded(value: EntityTargetValue<DragGesture.Value>) {
        let state = EntityGestureState.shared
        state.isDragging = false
        
        if resetOnEnded {
            // Asegurarse de que hay una entidad seleccionada.
            guard let entity = state.targetedEntity else { fatalError("El gesto no contiene una entidad") }
            
            entity.setOrientation(state.initialOrientation!, relativeTo: nil)
        }
    }

    // MARK: - Lógica de Escala
    
    // Maneja las acciones de `.onChanged` para los gestos de ampliación (escala).
    mutating func onChanged(value: EntityTargetValue<MagnifyGesture.Value>) {
        let state = EntityGestureState.shared
        // Verificar si se permite escalar y si no se está arrastrando.
        guard canScale, !state.isDragging else { return }
        
        let entity = value.entity
        
        // Si no se está escalando, inicializar el estado de ampliación.
        if !state.isScaling {
            state.isScaling = true
            state.startScale = entity.scale
        }
        
        // Aplicar la magnificación (escala) a la entidad.
        let magnification = Float(value.magnification)
        entity.scale = state.startScale * magnification
    }
    
    // Maneja las acciones de `.onEnded` para los gestos de ampliación (escala).
    mutating func onEnded(value: EntityTargetValue<MagnifyGesture.Value>) {
        let state = EntityGestureState.shared
        state.isScaling = false
        
        if resetOnEnded {
            // Asegurarse de que hay una entidad seleccionada.
            guard let entity = state.targetedEntity else { fatalError("El gesto no contiene una entidad") }
            
            entity.scale = state.startScale
        }
    }
    
    // MARK: - Lógica de Rotación
    
    // Maneja las acciones de `.onChanged` para los gestos de rotación.
    mutating func onChanged(value: EntityTargetValue<RotateGesture3D.Value>) {
        let state = EntityGestureState.shared
        // Verificar si se permite rotar y si no se está arrastrando.
        guard canRotate, !state.isDragging else { return }

        let entity = value.entity
        
        // Si no se está rotando, inicializar el estado de rotación.
        if !state.isRotating {
            state.isRotating = true
            state.startOrientation = .init(entity.orientation(relativeTo: nil))
        }
        
        // Invertir el eje de rotación y crear una nueva orientación.
        let rotation = value.rotation
        let flippedRotation = Rotation3D(angle: rotation.angle,
                                         axis: RotationAxis3D(x: -rotation.axis.x,
                                                              y: rotation.axis.y,
                                                              z: -rotation.axis.z))
        let newOrientation = state.startOrientation.rotated(by: flippedRotation)
        entity.setOrientation(.init(newOrientation), relativeTo: nil)
    }
    
    // Maneja las acciones de `.onEnded` para los gestos de rotación.
    mutating func onEnded(value: EntityTargetValue<RotateGesture3D.Value>) {
        let state = EntityGestureState.shared
        state.isRotating = false
        
        if resetOnEnded {
            // Asegurarse de que hay una entidad seleccionada.
            guard let entity = state.targetedEntity else { fatalError("El gesto no contiene una entidad") }
            
            entity.setOrientation(.init(state.startOrientation), relativeTo: nil)
        }
    }
}
