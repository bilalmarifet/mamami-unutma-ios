//
//  ImagePreview.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 4.11.2021.
//

import SwiftUI
import URLImage
struct ImagePreview: View {
    var imageURL: String?
    @Binding var showingSheet: Bool
    var body: some View {
        if let imageURL = imageURL {
            URLImage(URL(string: imageURL)!) { image in
                image
                    .resizable()
                    .cornerRadius(10)
                    .scaledToFit()
                    
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

//struct ImagePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePreview(imageURL: "", showingSheet: Binding<)
//    }
//}
