//
//  Shoe.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 16/8/24.
//

import SwiftUI
import SwiftData

// Enum para poder recuperar el color en el VM
enum ShoeColor: String, Codable, CaseIterable {
    case black = "Negro"
    case brown = "Marrón"
    case red = "Rojo"
    case white = "Blanco"
}

struct Shoe: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let brand: String
    let size: [Int]
    let price: Double
    let description: String
    let model3DName: String
    let type: String
    let materials: [String]
    let origin: String
    let gender: String
    let weight: Double
    let colors: [ShoeColor]
    let warranty: Int
    let certifications: [String]
    
    var isFav: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name, brand, size, price, description, model3DName, type, materials, origin, gender, weight, colors, warranty, certifications
    }
}

// Modelo para guardar los favoritos en BD
@Model
class FavShoe {
    @Attribute(.unique) let id: Int
    
    init(id: Int) {
        self.id = id
    }
}
