//
//  Extensions.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 20/8/24.
//

import SwiftUI
import RealityKit

public extension RealityView {
    
    // Aplica esto a un RealityView para pasar los gestos al código del componente.
    func installGestures() -> some View {
        simultaneousGesture(dragGesture)
            .simultaneousGesture(magnifyGesture)
            .simultaneousGesture(rotateGesture)
    }

    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .useGestureComponent()
    }
    
    var magnifyGesture: some Gesture {
        MagnifyGesture()
            .targetedToAnyEntity()
            .useGestureComponent()
    }
    
    var rotateGesture: some Gesture {
        RotateGesture3D()
            .targetedToAnyEntity()
            .useGestureComponent()
    }
}

public extension Entity {
    var gestureComponent: GestureComponent? {
        get { components[GestureComponent.self] }
        set { components[GestureComponent.self] = newValue }
    }

    var scenePosition: SIMD3<Float> {
        get { position(relativeTo: nil) }
        set { setPosition(newValue, relativeTo: nil) }
    }

    var sceneOrientation: simd_quatf {
        get { orientation(relativeTo: nil) }
        set { setOrientation(newValue, relativeTo: nil) }
    }
}

// MARK: - Rotación

public extension Gesture where Value == EntityTargetValue<RotateGesture3D.Value> {
    
    func useGestureComponent() -> some Gesture {
        onChanged { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            gestureComponent.onChanged(value: value)
            
            value.entity.components.set(gestureComponent)
        }
        .onEnded { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            gestureComponent.onEnded(value: value)
            
            value.entity.components.set(gestureComponent)
        }
    }
}

// MARK: - Arrastre (Drag)

public extension Gesture where Value == EntityTargetValue<DragGesture.Value> {
    
    func useGestureComponent() -> some Gesture {
        onChanged { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            gestureComponent.onChanged(value: value)
            
            value.entity.components.set(gestureComponent)
        }
        .onEnded { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            gestureComponent.onEnded(value: value)
            
            value.entity.components.set(gestureComponent)
        }
    }
}

// MARK: - Escala

public extension Gesture where Value == EntityTargetValue<MagnifyGesture.Value> {
    
    func useGestureComponent() -> some Gesture {
        onChanged { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            gestureComponent.onChanged(value: value)
            
            value.entity.components.set(gestureComponent)
        }
        .onEnded { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            gestureComponent.onEnded(value: value)
            
            value.entity.components.set(gestureComponent)
        }
    }
}
