//
//  Shoe.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import Foundation
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
}
