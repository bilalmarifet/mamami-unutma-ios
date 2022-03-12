//
//  AddPostSecond.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 25.10.2021.
//

import SwiftUI
import Resolver

struct AddPostSecond: View {
    
    @ObservedObject var addPostVM = AddPostViewModel()
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage? = nil
    @State private var title: String = ""
    @State private var description: String = ""
    @EnvironmentObject private var indexRouter: IndexRouter
    @State var showImagePickerOptions = false
    @State var sourceType = UIImagePickerController.SourceType.camera
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    Spacer(minLength: 20)
                    Button(action: {
                        print("button pressed")
                        showImagePickerOptions.toggle()
                    }) {
                        ( Image(uiImage: (image ?? UIImage(named: "AddPhoto"))!))
                        
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                    }
                    .actionSheet(isPresented: $showImagePickerOptions) {
                        ActionSheet(title: Text("Select"), message: Text("Choose Photo"), buttons: [
                            .default(Text("Photo Library")) { sourceType = .photoLibrary
                                showImagePicker = true },
                            .default(Text("Camera")) { sourceType = .camera
                                showImagePicker = true },
                        ])
                    }
                    
                    .fullScreenCover(isPresented: $showImagePicker) {
                        PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image, sourceType: .camera)
                    }
                    Spacer()
                    TextField("Title", text: $title)
                    Spacer()
                }
                HStack {
                    TextField("Description", text: $description)
                }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                
                Spacer()
            }
            .onAppear(perform: {
                UINavigationBar.appearance().backgroundColor = .clear
            })
            .navigationTitle("Add Post")
            .toolbar {
                Button(action: {
                    addPostVM.addTask(post: Post(title: title, description: description), image: image)
                    DispatchQueue.main.async {
                        indexRouter.currentIndex = 0
                    }
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 30))
                }
            }
        }
        
    }
}

struct AddPostSecond_Previews: PreviewProvider {
    static var previews: some View {
        AddPostSecond()
    }
}
