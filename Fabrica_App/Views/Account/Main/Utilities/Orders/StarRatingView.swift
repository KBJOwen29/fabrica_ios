//
//  StarRatingView.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    var max: Int = 5
    var interactive: Bool = true

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...max, id: \.self) { idx in
                Image(systemName: idx <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.system(size: 18, weight: .semibold))
                    .onTapGesture {
                        guard interactive else { return }
                        rating = idx
                    }
            }
        }
        .padding(.vertical, 6)
    }
}
