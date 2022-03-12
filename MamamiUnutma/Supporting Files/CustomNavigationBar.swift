//
//  NavigationBar.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 25.11.2021.
//

import SwiftUI

struct CustomNavigationBar: View {
    
    @State private var offset = 100.0
    @State private var opacity = 0.0
    @State private var rotation = 0.0
    let widthOfOne: Double
    let widthOfSec: Double
    var totalRollCount: Double
    @Binding var showSelf: Bool
    
    init(isActive: Binding<Bool>) {
        self.widthOfOne = -(UIScreen.screenWidth + 140)/5
        self.widthOfSec = -UIScreen.screenWidth + 140
        self.totalRollCount = abs(widthOfOne - widthOfSec) / ( 100 * 3.14) * 360
        _showSelf = isActive
    }
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                ZStack {
                    if showSelf != false {
                        Image("cat")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .offset(x: -UIScreen.screenWidth + 140, y: 0.0)
                        
                        Text("MAMAMI UNUTMA")
                            .foregroundColor(.white)
                            .offset(x: -UIScreen.screenWidth / 2 + 100 , y: 0.0)
                            .font(.headline)
                    }else {
                        Image("cat")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .rotationEffect(Angle.degrees(rotation), anchor: .center)
                            .offset(x: offset, y: 0.0)
                            .onAppear {
                                DispatchQueue.main.async {
                                    print("totalCount: ", totalRollCount)
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        offset = 360 - totalRollCount
                                        withAnimation(.easeIn(duration: 0.5)) {
                                            rotation = 360
                                            offset = -UIScreen.screenWidth + 140
                                        }
                                        withAnimation(.spring().delay(0.5)) {
                                            opacity = 1.0
                                        }
                                    }
                                }
                            }
                        
                        Text("MAMAMI UNUTMA")
                            .foregroundColor(.white)
                            .opacity(opacity)
                            .offset(x: -UIScreen.screenWidth / 2 + 100 , y: 0.0)
                            .font(.headline)
                    }
                }
            }.padding(.leading, -40)
            
        }.background(Color("BackgroundSecond"))
            .frame(width: UIScreen.screenWidth, height: 150, alignment: .center)
            .cornerRadius(80, corners:[.bottomLeft])
        
    }
}

//struct CustomNavigationBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomNavigationBar(isActive: <#Binding<Bool>?#>)
//    }
//}
