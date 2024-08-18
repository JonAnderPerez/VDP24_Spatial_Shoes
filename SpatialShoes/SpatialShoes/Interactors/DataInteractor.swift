//
//  DataInteractor.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import Foundation

protocol DataInteractor: JSONInteractor {
    var url: URL { get }
    
    func getShoes() throws -> [Shoe]
}

extension DataInteractor {
    var url: URL { Bundle.main.url(forResource: "Shoes", withExtension: "json")! }
    
    func getShoes() throws -> [Shoe] {
        return try loadJSON(url: url, type: [Shoe].self).sorted(by: { $0.id < $1.id })
    }
}

struct Interactor: DataInteractor {}
