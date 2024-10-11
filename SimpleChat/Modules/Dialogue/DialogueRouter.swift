//
//  DialogueRouter.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

import UIKit

protocol DialogueRouterInput: AnyObject {
    func show(on window: UIWindow)
}

final class DialogueRouter {
    weak var view: DialogueViewInput?
    private var viewController: UIViewController? {
        view as? UIViewController
    }
}

// MARK: - DialogueRouterInput

extension DialogueRouter: DialogueRouterInput {
    func show(on window: UIWindow) {
        guard let viewController = viewController else { return }
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
}
