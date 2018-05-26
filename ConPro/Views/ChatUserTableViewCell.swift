//
//  UserTableViewCell.swift
//  ChatApp
//
//  Created by Sergey on 5/23/18.
//  Copyright © 2018 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class ChatUserTableViewCell: UITableViewCell {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.masksToBounds = true
    }
}
