//
//  DialogueModule.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

import UIKit

protocol DialogueInput: AnyObject {
    func setInitialModule(on window: UIWindow)
}

protocol DialogueOutput: AnyObject {}

final class DialogueModule {
    let view: DialogueViewController
    let presenter: DialoguePresenter
    let router: DialogueRouter
    let dialogueInteractor: DialogueInteractor
    
    var output: DialogueOutput? {
        get { presenter.output }
        set { presenter.output = newValue }
    }
    var input: DialogueInput { presenter }

    init() {
        dialogueInteractor = DialogueInteractor()
        view = DialogueViewController()
        router = DialogueRouter()
        presenter = DialoguePresenter(router: router, dialogueInteractor: dialogueInteractor)
        view.output = presenter
        presenter.view = view
        router.view = view
        dialogueInteractor.output = presenter
    }
}
