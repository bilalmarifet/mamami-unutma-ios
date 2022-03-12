//
//  Profile.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 24.10.2021.
//

import SwiftUI
import Combine
import Firebase
struct Profile: View {
    let viewModel = ProfileViewModel()
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ImageView(withURL: viewModel.profile.profilPhoto)
                    Spacer()
                }
                List {
                    HStack {
                        Text(viewModel.profile.name)
                            .font(.system(size: 20))
                        Spacer()
                    }
                    
                    
                    Button("Logout") {
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("login"), object: nil)
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    }
                }
                
                
                
            }.background(Color("systemBackground"))
                .onAppear(perform: {
                    UINavigationBar.appearance().backgroundColor = .clear
                })
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Profilim")
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Tabbar()
    }
}




class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}


struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage(named: "cat-food")!
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    init(withURL url:String,width: CGFloat = 100, height: CGFloat =  100, cornerRadius: CGFloat = 50) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .frame(width: width, height:height)
            .cornerRadius(cornerRadius)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage(named: "cat-food")!
            }
    }
}
