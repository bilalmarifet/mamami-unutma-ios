//
//  UIApplication+Extensions.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 19.11.2021.
//

import Foundation
import SwiftUI
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
