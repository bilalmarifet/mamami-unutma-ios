//
//  ImagePreviewBubble.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 19.11.2021.
//

import Foundation
import SwiftUI
import URLImage
struct imagePreviewBubble: View {
    @State var showingSheet = false
    var imageUrl: String?
    var body: some View {
        if let imageUrl = imageUrl {
            Button(action: {
                showingSheet.toggle()
            }) {
                URLImage(URL(string: imageUrl)!) { image in
                    image
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                        .scaledToFit()
                }
            }
            .sheet(isPresented: $showingSheet) {
                ImagePreview(imageURL: imageUrl, showingSheet: $showingSheet)
            }
        }
    }
}

