//
//  FavShoeInteractor.swift
//  SpatialShoes
//
//  Created by Jon Ander Perez on 27/8/24.
//

import Foundation
import SwiftData

protocol FavInteractor {
    var modelContainer: ModelContainer { get }
    var modelContext: ModelContext { get }
    
    func appendFav(item: FavShoe) throws
    func fetchFav() throws -> [FavShoe]
    func removeFav(_ item: FavShoe) throws
}

struct FavShoeInteractor: FavInteractor {
    @MainActor
    static let shared = FavShoeInteractor()
    
    var modelContainer: ModelContainer
    var modelContext: ModelContext

    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: FavShoe.self)
        self.modelContext = modelContainer.mainContext
    }

    func appendFav(item: FavShoe) throws {
        modelContext.insert(item)
        try modelContext.save()
    }

    func fetchFav() throws -> [FavShoe] {
        return try modelContext.fetch(FetchDescriptor<FavShoe>())
    }

    func removeFav(_ item: FavShoe) throws {
        modelContext.delete(item)
        try modelContext.save()
    }
}
