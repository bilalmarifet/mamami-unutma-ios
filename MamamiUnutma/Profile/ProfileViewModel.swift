//
//  ProfileViewModel.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 24.10.2021.
//

import Foundation
import Firebase

class ProfileViewModel  {

    var profile = ProfileModel.temp
    
    init() {
        profile.name = Auth.auth().currentUser?.displayName ?? profile.name
        profile.profilPhoto = Auth.auth().currentUser?.photoURL?.absoluteString ??  profile.profilPhoto
    }
}
