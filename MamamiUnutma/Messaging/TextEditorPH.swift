//
//  asdas.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 19.11.2021.
//

import SwiftUI

struct TextEditorPH: View {
    
    private var placeholder: String
    @Binding var text: String
    
    init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextEditor(text: self.$text)
            // make the color of the placeholder gray
            .foregroundColor(self.text == placeholder ? .gray : .primary)
            
            .onAppear {
                // create placeholder
                self.text = placeholder

                // remove the placeholder text when keyboard appears
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                    withAnimation {
                        if self.text == placeholder {
                            self.text = ""
                        }
                    }
                }
                
                // put back the placeholder text if the user dismisses the keyboard without adding any text
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    withAnimation {
                        if self.text == "" {
                            self.text = placeholder
                        }
                    }
                }
            }
    }
}
