//
//  DialogueInteractor.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

import Foundation

protocol DialogueInteractorInput: AnyObject {
    func userDidSendMessage(_ text: String)
}

protocol DialogueInteractorOutput: AnyObject {
    func didProcessMessage(_ message: Message)
}

final class DialogueInteractor {
    weak var output: DialogueInteractorOutput?
}

extension DialogueInteractor: DialogueInteractorInput {
    func userDidSendMessage(_ text: String) {
        let message = Message(id: UUID(), text: text, isSentByCurrentUser: true)
        output?.didProcessMessage(message)

        Task.detached(priority: .background) {
            // Добавляю паузу на полсекунды, чтобы имитировать запрос на сервер
            try? await Task.sleep(nanoseconds: 500_000_000)

            let reversedMessageText = self.reverseMessage(text)
            let reversedMessage = Message(id: UUID(), text: reversedMessageText, isSentByCurrentUser: false)

            await MainActor.run {
                self.output?.didProcessMessage(reversedMessage)
            }
        }
    }
    
    private func reverseMessage(_ message: String) -> String {
        return String(message.reversed())
    }
}
