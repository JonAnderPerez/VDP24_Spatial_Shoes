//
//  FlexibleView.swift
//  SpatialShoes
//
//  Created by Deusto SEIDOR on 3/9/24.
//

import SwiftUI

struct FlexibleTextView: View {
    let data: [String]
    let spacing: CGFloat
    
    @State private var totalHeight: CGFloat?

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.data, id: \.self) { item in
                Text(item)
                    .font(.largeTitle)
                    .foregroundStyle(.primary)
                    .padding()
                    .glassBackgroundEffect()
                    .padding([.horizontal, .vertical], self.spacing)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == self.data.last {
                            width = 0 // último item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == self.data.last {
                            height = 0 // último item
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat?>) -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.size.height
            }
            return Color.clear
        }
    }
}
