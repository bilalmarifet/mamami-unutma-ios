//
//  Main.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 24.10.2021.
//

import SwiftUI
import SwiftUIRefresh
import URLImage
struct Main: View {
    
    @ObservedObject var mainVM = MainViewModel()
    @State private var showMessage = false
    var body: some View {
        
        NavigationView {
            
            HStack {
                switch mainVM.state {
                case .loading, .idle:
                    ProgressView()
                case .loaded(let posts):
                    if posts.count == 0 {
                        Image("cat-food")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250, alignment: .center)
                        Divider()
                            .padding(.vertical, 8)
                        Text("Yakınlarda yardıma muhtaç hayvan bulunamadı").font(.title3).fontWeight(.light)
                    }
                    else {
                        Form {
                            Section {
                                ForEach (posts) { item in
                                    NavigationLink(destination: Messaging(post: item)) {
                                        HStack {
                                            if let url = URL(string: item.image ?? "") {
                                                URLImage(url) {
                                                    // This view is displayed before download starts
                                                    Image("cat-food")
                                                        .resizable()
                                                        .frame(width: 80, height: 80)
                                                        .scaledToFit()
                                                } inProgress: { progress in
                                                    // Display progress
                                                    Image("cat-food")
                                                        .resizable()
                                                        .frame(width: 80, height: 80)
                                                        .scaledToFit()
                                                } failure: { error, retry in
                                                    // Display error and retry button
                                                    Image("cat-food")
                                                        .resizable()
                                                        .frame(width: 80, height: 80)
                                                        .scaledToFit()
                                                } content: { image in
                                                    // Downloaded image
                                                    image
                                                        .resizable()
                                                        .frame(width: 80, height: 80)
                                                        .cornerRadius(5)
                                                        .aspectRatio(contentMode: .fit)
                                                }
                                            }
                                            else{
                                                Image("cat-food")
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text(item.title)
                                                    .font(.title3)
                                                    .fontWeight(.bold)
                                                Text(item.description)
                                                    .font(.subheadline)
                                                    .fontWeight(.light)
                                                
                                            }
                                        }.padding(.leading, -10)
                                    }
                                }
                                .padding()
                                
                            }
                        }
                        
                    }
                case .failed(_):
                    EmptyView()
                }
                
            }
            .onAppear(perform: {
                UINavigationBar.appearance().backgroundColor = .clear
            })
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Yakınımdakiler")
        }
        
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Tabbar()
    }
}
