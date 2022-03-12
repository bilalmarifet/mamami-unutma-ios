//
//  View+Extensions.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 19.11.2021.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func configureNavigationBar(configure: @escaping (UINavigationController) -> Void) -> some View {
        modifier(NavigationConfigurationViewModifier(configure: configure))
    }
}

struct NavigationConfigurationViewModifier: ViewModifier {
    let configure: (UINavigationController) -> Void

    func body(content: Content) -> some View {
        content.background(NavigationConfigurator(configure: configure))
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    let configure: (UINavigationController) -> Void

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<NavigationConfigurator>
    ) -> NavigationConfigurationViewController {
        NavigationConfigurationViewController(configure: configure)
    }

    func updateUIViewController(
        _ uiViewController: NavigationConfigurationViewController,
        context: UIViewControllerRepresentableContext<NavigationConfigurator>
    ) { }
}

final class NavigationConfigurationViewController: UIViewController {
    let configure: (UINavigationController) -> Void

    init(configure: @escaping (UINavigationController) -> Void) {
        self.configure = configure
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let navigationController = navigationController {
            configure(navigationController)
        }
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
