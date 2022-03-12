//
//  SignUpView.swift
//  FirebaseLogin
//
//  Created by Mavis II on 9/2/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
struct actIndSignup: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var showSelf: Bool
    @ObservedObject var vm = SignUpViewModel()
    @State var sourceType = UIImagePickerController.SourceType.camera
    
    var body: some View {
            VStack {
                CustomNavigationBar(isActive: self.$showSelf)
                Button(action: {
                    print("button pressed")
                    showSelf.toggle()
//                    vm.showImagePickerOptions.toggle()
                }) {
                    Image(uiImage:((vm.image ?? UIImage(systemName: "plus.circle.fill"))!))
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                }
                .actionSheet(isPresented: $vm.showImagePickerOptions) {
                    ActionSheet(title: Text("Select"), message: Text("Choose Photo"), buttons: [
                        .default(Text("Photo Library")) { sourceType = .photoLibrary
                            vm.showImagePicker = true },
                        .default(Text("Camera")) { sourceType = .camera
                            vm.showImagePicker = true },
                    ])
                }
                .fullScreenCover(isPresented: $vm.showImagePicker) {
                    PhotoCaptureView(showImagePicker: $vm.showImagePicker, image: $vm.image, sourceType: sourceType)
                }
                Text("Name").font(.title).fontWeight(.thin).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                
                Group {
                    TextField("Oguz", text: $vm.name, onEditingChanged: { (isChanged) in
                        if !isChanged {
                            vm.validateName()
                        }
                    })
                        .onChange(of: vm.name, perform: { newValue in
                            if !vm.isNameValid {
                                vm.validateName()
                            }
                        })
                        .textContentType(.name)
                    Divider().background(vm.isNameValid ? nil : Color.red)
                    if !vm.isNameValid {
                        HStack {
                            
                            Text("Name must be at least 3 characters")
                                .font(.callout)
                                .foregroundColor(Color.red)
                            Spacer()
                        }
                    }
                    Text("Email").font(.title).fontWeight(.thin).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                    
                    TextField("user@email.com", text: $vm.emailAddress, onEditingChanged: { (isChanged) in
                        if !isChanged {
                            vm.textFieldValidatorEmail()
                        }
                    })
                        .onChange(of: vm.emailAddress, perform: { newValue in
                            if !vm.isEmailValid {
                                vm.textFieldValidatorEmail()
                            }
                        })
                        .textContentType(.emailAddress)
                    Divider().background(vm.isEmailValid ? nil : Color.red)
                    if !vm.isEmailValid {
                        HStack {
                            Text("Email is Not Valid")
                                .font(.callout)
                                .foregroundColor(Color.red)
                            Spacer()
                        }
                        
                    }
                    Text("Password").font(.title).fontWeight(.thin)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                    
                    SecureField("Enter a password", text: $vm.password, onCommit: {
                        vm.signUpWithEmailPassword()
                    })
                        .onTapGesture(perform: {
                            vm.isPasswordValid = true
                        })
                    Group {
                        Divider().background(vm.isPasswordValid ? nil : Color.red)
                        if !vm.isPasswordValid {
                            HStack {
                                
                                
                                Text("Password must be at least 6 characters")
                                    .font(.callout)
                                    .foregroundColor(Color.red)
                                Spacer()
                            }
                        }
                    }
                }
                
                Spacer()
                HStack {
                    Spacer()
                    Button(action:{
                        vm.signUpWithEmailPassword()
                    }) {
                        vm.isLoading ? AnyView(ProgressView()) : AnyView(Text("SignUp"))
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(minWidth: 100,maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 10, x: 0, y: 2)
                    .opacity(0.9)
                    Spacer()
                    
                }
                
                Text(vm.errorText).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                
            }.padding(10)
                .navigationBarHidden(true)
                .navigationTitle("")
        
    }
}

