//
//  DialogueViewController.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

import UIKit

protocol DialogueViewInput: AnyObject {
    func configure()
    func didReceiveMessage(message: Message)
}

protocol DialogueViewOutput: AnyObject {
    func viewDidLoad()
    func sendMessageDidTap(message: String)
}

final class DialogueViewController: UIViewController {
    enum Section {
        case main
    }

    private enum Constants {
        static let itemSpacing: CGFloat = 10
        static let sectionInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 70, trailing: 10)
        static let textFieldHeight: CGFloat = 50
        static let textFieldCornerRadius: CGFloat = 25
        static let textFieldPadding: CGFloat = 15
        static let sendButtonSize = CGSize(width: 50, height: 50)
        static let sendButtonTrailingPadding: CGFloat = 1
        static let animationDuration: TimeInterval = 0.3
        static let keyboardBottomInset: CGFloat = 0
        static let maxCharacterLimit = 300
    }

    var output: DialogueViewOutput?
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Message>!
    lazy var textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()

        configureDataSource()
        applyInitialSnapshot()
        configureKeyboardNotifications()
        configureGestures()
    }
}

// MARK: - Private methods

private extension DialogueViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(Constants.textFieldHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(Constants.textFieldHeight))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Constants.itemSpacing
            section.contentInsets = Constants.sectionInsets

            return section
        }
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Message>(collectionView: collectionView) { (collectionView, indexPath, message) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseIdentifier, for: indexPath) as! MessageCell
            cell.configure(with: message)
            return cell
        }
    }

    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapshot.appendSections([.main])

        // Данные для теста
        snapshot.appendItems([
            Message(id: UUID(), text: "Привет, как дела?", isSentByCurrentUser: true),
            Message(id: UUID(), text: "Все отлично! Как у тебя?", isSentByCurrentUser: false),
        ], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func configureKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height
        adjustForKeyboard(isShowing: true, keyboardHeight: keyboardHeight)
    }

    @objc func keyboardWillHide(notification: Notification) {
        adjustForKeyboard(isShowing: false, keyboardHeight: Constants.keyboardBottomInset)
    }

    @objc func sendButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        output?.sendMessageDidTap(message: text)
        textField.text = ""
    }

    func adjustForKeyboard(isShowing: Bool, keyboardHeight: CGFloat) {
        let bottomInset = isShowing ? keyboardHeight : Constants.keyboardBottomInset
        collectionView.contentInset.bottom = bottomInset
        collectionView.verticalScrollIndicatorInsets.bottom = bottomInset

        UIView.animate(withDuration: Constants.animationDuration) {
            self.textField.transform = CGAffineTransform(translationX: 0, y: -bottomInset)
        }
    }

    func setUpLayout() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)
        view.addSubview(textField)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.itemSpacing),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.itemSpacing),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight)
        ])
    }

    func setUpViews() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGray6
        view.addSubview(collectionView)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseIdentifier)

        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.textFieldCornerRadius
        textField.layer.masksToBounds = true
        textField.borderStyle = .none
        textField.delegate = self

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.textFieldPadding, height: Constants.textFieldHeight))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        let sendButton = UIButton(type: .system)
        if let sendIcon = UIImage(named: "sendIcon") {
            sendButton.setImage(sendIcon, for: .normal)
        }
        sendButton.imageView?.clipsToBounds = true
        sendButton.frame = CGRect(origin: .zero, size: Constants.sendButtonSize)
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        let sendButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: Constants.sendButtonSize.width + Constants.sendButtonTrailingPadding, height: Constants.sendButtonSize.height))
        sendButtonContainer.addSubview(sendButton)

        textField.rightView = sendButtonContainer
        textField.rightViewMode = .always

        view.addSubview(textField)
    }

}

extension DialogueViewController: DialogueViewInput {
    func configure() {
        setUpViews()
        setUpLayout()
    }

    func didReceiveMessage(message: Message) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([message], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)

        let indexPath = IndexPath(item: snapshot.numberOfItems(inSection: .main) - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
}

extension DialogueViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return updatedText.count <= Constants.maxCharacterLimit
    }
}
