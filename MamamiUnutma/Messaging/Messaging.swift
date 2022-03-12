//
//  Messaging.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 1.11.2021.
//

import SwiftUI
import Combine



import URLImage

struct Messaging: View {
    @ObservedObject var messagingVM: MessagingViewModel
    var post: Post
    @EnvironmentObject private var indexRouter: IndexRouter
    @State var typingMessage: String = ""
    init(post: Post) {
        UINavigationBar.appearance().backgroundColor = UIColor(named: "BackgroundColor")
        self.post = post
        messagingVM = MessagingViewModel(post: post)
    }
    @State var sourceType = UIImagePickerController.SourceType.camera
    var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @State private var imageWillSend: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var showingSheet = false
    
    var body: some View {
//        GeometryReader { geo in
            VStack {
                VStack {
                //MARK:- ScrollView
                CustomScrollView(scrollToEnd: true) {
                    LazyVStack {
                        ForEach(messagingVM.messagesCellList) { value in
                            ChatBubble(position: value.position, color: Color(value.color ?? "BubbleColor-10")) {
                                VStack(alignment: value.position == BubblePosition.center ? .center : .trailing) {
                                    HStack {
                                        imagePreviewBubble(imageUrl: value.imageURL)
                                        Text(value.message)
                                    }
                                    switch value.position {
                                    case .center:
                                        MapPreviewPreview(latitude: post.latitude, longitude: post.longitude)
                                        
                                    default:
                                        EmptyView()
                                    }
                                    if let userName = value.userName {
                                        HStack {
                                            Text(userName)
                                                .font(.system(size: 13.0))
                                                .fontWeight(.light)

                                        }.padding(.top, 5)
                                    } else {
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }.padding(.top)
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                
                    VStack {
                        //MARK:- text editor
                        
                            if let image = imageWillSend {
                                
                                ZStack {
                                    ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Button(action: {
                                            self.imageWillSend = nil
                                        }) {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .foregroundColor(.red)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .cornerRadius(10)
                                        }
                                        .padding()
                                    }
                                    Image(uiImage: image)
                                        .resizable()
                                        .cornerRadius(10)
                                        .frame(width: 250, height: 250)
                                    
                                }
                                
                                .frame(
                                    minWidth: 0,
                                    maxWidth: .infinity,
                                    minHeight: 0,
                                    maxHeight: .infinity
                                ).background(Color.clear)
                                
                            }
                        VStack {
                            HStack {
                                Button(action: {
                                    UIApplication.shared.endEditing()
                                    messagingVM.showImagePickerOptions.toggle()
                                }) {
                                    Image(systemName: "camera.fill")
                                        .resizable()
                                        .foregroundColor(Color("SendButton"))
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                }
                                .actionSheet(isPresented: $messagingVM.showImagePickerOptions) {
                                    ActionSheet(title: Text("Select"), message: Text("Choose Photo"), buttons: [
                                        .default(Text("Photo Library")) { sourceType = .photoLibrary
                                            showImagePicker = true },
                                        .default(Text("Camera")) { sourceType = .camera
                                            showImagePicker = true },
                                    ])
                                }
                                .fullScreenCover(isPresented: $showImagePicker) {
                                    PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$imageWillSend, sourceType: sourceType)
                                }
                                
                                ZStack {
                                    TextEditorPH(placeholder: "Type Text", text: $typingMessage)
                                        .padding(.top, 5)
                                        .ignoresSafeArea(.keyboard, edges: .bottom)
                                }.frame(height: 40)
                                    .opacity((imageWillSend != nil) ? 0.5 : 1)
                                    .disabled((imageWillSend != nil))
                                
                                
                                Button(action: {
                                    if typingMessage != "" {
                                        sendMessage(messageContent: typingMessage)
                                        typingMessage = ""
                                    }else if imageWillSend != nil {
                                        sendMessage(messageContent: "")
                                    }
                                }) {
                                    Image(systemName: "paperplane.circle.fill")
                                        .resizable()
                                        .foregroundColor(Color("SendButton"))
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .background(Color.white)
                            .padding()
                            .padding(.bottom, 10)
                            
                        }
                        .background(Color.white)
                        .compositingGroup()
                        .shadow(radius: 8)
                    }.background(Color.clear)
                
            }
                
                .padding(.top, 100)
            }
//        }
        .background(Color("BackgroundColor"))
        .configureNavigationBar {
            
            $0.navigationBar.backgroundColor = UIColor(named: "BackgroundColor")
//                    $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
//                    $0.navigationBar.shadowImage = UIImage()
                }
        .ignoresSafeArea(.container, edges: .bottom)
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(post.title)
        .onAppear {
            indexRouter.isHideNavBar = true
        }
        .onDisappear {
            indexRouter.isHideNavBar = false
        }
        .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    messagingVM.isPostCreaterIsSelf ?
                    AnyView(Button(action: {
                        messagingVM.removePost()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "minus.circle")
                            .imageScale(.large)
                            .foregroundColor(.red)
                    }) : nil
                }
        })
    }
    
    func sendMessage(messageContent: String) {
        messagingVM.sendMessage(messageContent, image: imageWillSend)
        imageWillSend = nil
    }
    
}

