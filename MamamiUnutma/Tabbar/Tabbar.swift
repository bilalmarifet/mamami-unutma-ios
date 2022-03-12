//
//  Tabbar.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 24.10.2021.
//

import SwiftUI
import AVFoundation


class IndexRouter: ObservableObject {
    // here you can decide which view to show at launch
    @Published var currentIndex = 0
    @Published var isHideNavBar = false
}


struct Tabbar: View {
    
    init() {
        UITabBar.appearance().barTintColor = .systemBackground
        UINavigationBar.appearance().barTintColor = .systemBackground
    }
    @StateObject var indexRouter = IndexRouter()
    @State var shouldShowModal = false
    
    let tabBarImageNames = ["house.fill", "plus.app.fill", "person.fill"]
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                
                
                
                switch indexRouter.currentIndex {
                case 0:
                    Main()
                        .environmentObject(indexRouter)
                    
                case 1:
                    AddPostSecond()
                        .environmentObject(indexRouter)
                case 2:
                    Profile()
                        .environmentObject(indexRouter)
                default:
                    NavigationView {
                        Text("Remaining tabs")
                    }
                }
                
            }
            
            //            Spacer()
            if !indexRouter.isHideNavBar {
                
                Divider()
                    .padding(.bottom, 8)
                
                HStack {
                    ForEach(0..<3) { num in
                        Button(action: {
                            indexRouter.currentIndex = num
                        }, label: {
                            Spacer()
                            
                            if num == 1 {
                                Image(systemName: tabBarImageNames[num])
                                    .font(.system(size: 44, weight: .bold))
                                    .foregroundColor(.red)
                            } else {
                                Image(systemName: tabBarImageNames[num])
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(indexRouter.currentIndex == num ? Color(.black) : .init(white: 0.8))
                            }
                            
                            
                            Spacer()
                        })
                        
                    }
                }
            }
            
            
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}


struct Tabbar_Previews: PreviewProvider {
    static var previews: some View {
        Tabbar()
    }
}
