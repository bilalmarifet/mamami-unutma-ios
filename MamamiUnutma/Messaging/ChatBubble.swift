//
//  ChatBubble.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 19.11.2021.
//

import Foundation
import SwiftUI

enum BubblePosition {
    case left
    case right
    case center
}



struct ChatBubble<Content>: View where Content: View {
    let position: BubblePosition
    let color : Color
    let content: () -> Content
    init(position: BubblePosition, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.color = color
        self.position = position
    }
    
    var body: some View {
        
        if position == .center {
            HStack(spacing: 0 ) {
                content()
                    .padding(.all, 10)
                    .foregroundColor(Color.white)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        
                        Image(systemName: "arrowtriangle.left.fill")
                            .foregroundColor(color)
                            .rotationEffect(Angle(degrees: -50))
                            .offset(x: -5)
                        ,alignment: .bottomLeading )
                
                    .overlay(
                        Image(systemName: "arrowtriangle.left.fill")
                            .foregroundColor(color)
                            .rotationEffect(Angle(degrees:  -130))
                            .offset(x: 5)
                        ,alignment: .bottomTrailing)
                
            }
            .padding(.horizontal , 15)
            .frame(width: UIScreen.main.bounds.width, alignment: .center)
        }
        else {
            HStack(spacing: 0 ) {
                content()
                    .padding(.all, 10)
                    .foregroundColor(Color.white)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        Image(systemName: "arrowtriangle.left.fill")
                            .foregroundColor(color)
                            .rotationEffect(Angle(degrees: position == .left ? -50 : -130))
                            .offset(x: position == .left ? -5 : 5)
                        ,alignment: position == .left ? .bottomLeading : .bottomTrailing)
            }
            .padding(position == .left ? .leading : .trailing , 15)
            .padding(position == .right ? .leading : .trailing , 60)
            .frame(width: UIScreen.main.bounds.width, alignment: position == .left ? .leading : .trailing)
        }
    }
}
