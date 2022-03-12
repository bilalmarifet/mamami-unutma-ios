//
//  PhotoCaptureView.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 25.10.2021.
//

import SwiftUI

struct PhotoCaptureView: View {
    
    @Binding var showImagePicker: Bool
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    var body: some View {
        ImagePicker(sourceType: sourceType, isShown: $showImagePicker, image: $image)
            .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(showImagePicker: .constant(false), image: .constant(UIImage(contentsOfFile: "")), sourceType: .camera)
    }
}
#endif
