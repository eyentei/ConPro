import UIKit

class PersonalMessageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
    }
}
