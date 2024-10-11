//
//  ViewController.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

import UIKit

protocol DialogueViewInput: AnyObject {
    func configure()
    func didReceiveMessage(message: String)
}

protocol DialogueViewOutput: AnyObject {
    func viewDidLoad()
    func sendMessageDidTap(message: String)
}

final class DialogueViewController: UIViewController {

    var output: DialogueViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        output?.viewDidLoad()
    }
}

extension DialogueViewController: DialogueViewInput {
    func configure() {}
    
    func didReceiveMessage(message: String) {}
}
