//
//  SignUpViewModel.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 18.11.2021.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseStorage


class SignUpViewModel: ObservableObject {
    @Published var emailAddress: String = ""
    @Published var isEmailValid: Bool = true
    @Published var name: String = ""
    @Published var isNameValid: Bool = true
    @Published var password: String = ""
    @Published var isPasswordValid: Bool = true
    @Published var agreeCheck: Bool = false
    @Published var errorText: String = ""
    @Published var showAlert = false
    @Published var isLoading = false
    @Published var showImagePicker: Bool = false
    @Published var image: UIImage? = nil
    
    @Published var isNavigationBarHidden: Bool = true
    @Published var showImagePickerOptions = false
    
    
    func validatePassword() -> Bool {
        if password.count < 6 {
            isPasswordValid = false
            return false
        }else {
            isPasswordValid = true
            return true
        }
    }
    
    func validateName() -> Bool {
        if name.count < 3 {
            isNameValid = false
            return false
        }else {
            isNameValid = true
            return true
        }
    }
    
    func textFieldValidatorEmail() -> Bool {
        if emailAddress.count > 100 {
            isEmailValid = false
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if !emailPredicate.evaluate(with: emailAddress) {
            isEmailValid = false
            return false
        }else {
            isEmailValid = true
            return true
        }
    }
    func signUpWithEmailPassword() {
        let isEmailValidated = textFieldValidatorEmail()
        let isPasswordValidated = validatePassword()
        let isNameValidated = validateName()
        if isEmailValidated && isPasswordValidated && isNameValidated {
            isLoading = true
            Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
                
                guard let user = authResult?.user, error == nil else {
                    
                    let errorText: String  = error?.localizedDescription ?? "unknown error"
                    self.errorText = errorText
                    self.isLoading = false
                    return
                }
                
                // add photo and name
                
                let changeRequeset = user.createProfileChangeRequest()
                self.uploadPhotoToFIRStorage(image: self.image) { url in
                    if let urlStringOfImage = url {
                        changeRequeset.photoURL = URL(string: urlStringOfImage)
                        
                    }
                    changeRequeset.displayName = self.name
                    changeRequeset.commitChanges { error in
                        if let error = error {
                            self.errorText = error.localizedDescription
                        }
                        else {
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("login"), object: nil)
                        }
                    }
                }
                self.isLoading = false
                
            }
        }}
    
    func uploadPhotoToFIRStorage(image: UIImage?, handler:@escaping (_ url:String?)-> Void){
        guard let image = image else { return handler(nil) }
        let filePath = "\(Auth.auth().currentUser!.uid)/\("userPhoto")"
        let metaData = StorageMetadata()
        
        let data = image.jpegData(compressionQuality: 0.5)!
        metaData.contentType = "image/jpg"
        let storageRef = Storage.storage().reference()
        storageRef.child(filePath)
            .putData(data, metadata: metaData) { (metaData, error) in
                if let error = error {
                    print("error", error.localizedDescription)
                    handler(nil)
                }
                else {
                    storageRef.child(filePath)
                        .downloadURL { url, error in
                            if let error = error {
                                print(error)
                                handler(nil)
                            }
                            else {
                                handler(url?.absoluteString)
                            }
                        }
                }
            }
    }
    
    
    
}
