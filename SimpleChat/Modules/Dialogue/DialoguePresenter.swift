//
//  DialoguePresenter.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

import UIKit

final class DialoguePresenter {
    let router: DialogueRouterInput
    let dialogueInteractor: DialogueInteractor
    
    weak var view: DialogueViewInput?
    weak var output: DialogueOutput?

    init(router: DialogueRouterInput, dialogueInteractor: DialogueInteractor) {
        self.router = router
        self.dialogueInteractor = dialogueInteractor
    }
}

// MARK: - DialogueViewOutput

extension DialoguePresenter: DialogueViewOutput {
    func viewDidLoad() {
        view?.configure()
    }

    func sendMessageDidTap(message: String) {
        dialogueInteractor.userDidSendMessage(message)
    }
}

// MARK: - DialogueInteractorOutput

extension DialoguePresenter: DialogueInteractorOutput {
    func didProcessMessage(_ message: Message) {
        view?.didReceiveMessage(message: message)
    }
}

// MARK: - DialogueInput

extension DialoguePresenter: DialogueInput {
    func setInitialModule(on window: UIWindow) {
        router.show(on: window)
    }
}

