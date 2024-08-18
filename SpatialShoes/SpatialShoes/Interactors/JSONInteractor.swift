//
//  JSONInteractor.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 16/8/24.
//

import Foundation

protocol JSONInteractor {}

extension JSONInteractor {
    func loadJSON<T>(url: URL, type: T.Type) throws -> T where T: Codable {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }
}
