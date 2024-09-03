//
//  ShoesScrollView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 21/8/24.
//

import SwiftUI

struct ShoesScrollView: View {
    @Environment(ShoesViewModel.self) private var vm
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(vm.shoes.filter({ $0.id != vm.selectedShoe?.id })) { shoe in
                    ShoeCard(shoe: shoe, isNavigationCard: true, rotate: false, isFav: .init(get: { shoe.isFav }, set: { newVal in vm.toggleFavShoe(id: shoe.id, isFav: newVal) }))
                }
            }
        }
        .safeAreaPadding(.vertical, 32)
        .safeAreaPadding(.horizontal)
        .scrollIndicators(.never)
        .frame(minWidth: 700, maxWidth: 1200, minHeight: 450, maxHeight: 450)
    }
}

#Preview(windowStyle: .plain) {
    ShoesScrollView.preview
}
