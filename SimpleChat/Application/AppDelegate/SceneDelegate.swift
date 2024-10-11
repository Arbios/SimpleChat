//
//  SceneDelegate.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        if let window = window {
            let module = DialogueModule()
            module.input.setInitialModule(on: window)
            window.makeKeyAndVisible()
        }
    }
}
