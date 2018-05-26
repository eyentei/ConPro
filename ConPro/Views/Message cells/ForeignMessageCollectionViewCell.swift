import UIKit

class ForeignMessageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var messageTimeLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var senderAvatarImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 12
        senderAvatarImageView.layer.cornerRadius = senderAvatarImageView.frame.width / 2
        senderAvatarImageView.contentMode = .scaleAspectFit
        senderAvatarImageView.layer.masksToBounds = true
        containerView.layer.masksToBounds = true
    }
}
