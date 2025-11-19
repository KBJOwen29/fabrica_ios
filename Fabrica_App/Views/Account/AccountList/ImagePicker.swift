//
//  ImagePicker.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/19/25.
//


import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var imageData: Data?
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            Label("Choose Photo", systemImage: "photo.on.rectangle")
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.primary.opacity(0.3)))
        }
        .onChange(of: selectedItem) { newItem in
            guard let item = newItem else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
}
