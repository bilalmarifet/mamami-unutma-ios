//
//  Splash.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 26.10.2021.
//

import SwiftUI
import Firebase

struct Splash: View {
    @EnvironmentObject var session: SessionStore

     func getUser () {
         session.listen()
     }

     var body: some View {
         
       Group {
         if (Auth.auth().currentUser != nil) {
             Tabbar()
         } else {
           let vm = LoginViewModel(session: session)
             Login(vm: vm)
         }
       }.onAppear(perform: getUser)
     }
}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}


