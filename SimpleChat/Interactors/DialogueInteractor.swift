//
//  DialogueInteractor.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

protocol DialogueInteractorInput: AnyObject {
    func sendMessage(_ message: String)
}

protocol DialogueInteractorOutput: AnyObject {
    func userDidSendMessage(_ message: String)
}

final class DialogueInteractor {
    weak var output: DialogueInteractorOutput?
}

extension DialogueInteractor: DialogueInteractorInput {
    func sendMessage(_ message: String) {
        output?.userDidSendMessage(message)
    }
}
