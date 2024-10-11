//
//  MessageCell.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

import UIKit

class MessageCell: UICollectionViewCell {
    static let reuseIdentifier = "MessageCell"

    private enum Constants {
        static let cornerRadius: CGFloat = 15
        static let bubbleTopBottomPadding: CGFloat = 5
        static let bubbleHorizontalPadding: CGFloat = 10
        static let messageLabelPadding: CGFloat = 15
        static let maxBubbleWidthMultiplier: CGFloat = 0.75
        static let messageFontSize: CGFloat = 13
        static let sentByCurrentUserBackgroundColor = UIColor.black
        static let sentByCurrentUserTextColor = UIColor.systemGray6
        static let receivedMessageBackgroundColor = UIColor.white
        static let receivedMessageTextColor = UIColor.black
    }

    private let messageLabel = UILabel()
    private let bubbleBackgroundView = UIView()
    private var bubbleLeadingConstraint: NSLayoutConstraint?
    private var bubbleTrailingConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        bubbleBackgroundView.clipsToBounds = true
        bubbleBackgroundView.layer.cornerRadius = Constants.cornerRadius
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)

        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)

        bubbleLeadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.bubbleHorizontalPadding)
        bubbleTrailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.bubbleHorizontalPadding)

        let constraints = [
            bubbleBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.bubbleTopBottomPadding),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bubbleTopBottomPadding),

            messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: Constants.messageLabelPadding),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -Constants.messageLabelPadding),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: Constants.messageLabelPadding),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -Constants.messageLabelPadding),
        ]

        NSLayoutConstraint.activate(constraints)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with message: Message) {
        messageLabel.text = message.text
        bubbleBackgroundView.backgroundColor = message.isSentByCurrentUser ? Constants.sentByCurrentUserBackgroundColor : Constants.receivedMessageBackgroundColor
        messageLabel.textColor = message.isSentByCurrentUser ? Constants.sentByCurrentUserTextColor : Constants.receivedMessageTextColor
        messageLabel.font = .systemFont(ofSize: Constants.messageFontSize)
        messageLabel.textAlignment = message.isSentByCurrentUser ? .right : .left

        bubbleLeadingConstraint?.isActive = !message.isSentByCurrentUser
        bubbleTrailingConstraint?.isActive = message.isSentByCurrentUser

        if message.isSentByCurrentUser {
            bubbleBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            bubbleBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }
}

