import UIKit
import AudioToolbox

protocol ChatMessageDelegate: class {
    func didTapUserImageView(in cell: UICollectionViewCell)
    func didSelectContextMenu(in cell: UICollectionViewCell)
}

class ForeignMessageCollectionViewCell: UICollectionViewCell {
    //MARK: Outlets
    @IBOutlet weak var messageTimeLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var senderAvatarImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    weak var delegate : ChatMessageDelegate?
    
    //MARK: Fields
    private var messageLongPressGestureRecognizer : UILongPressGestureRecognizer!
    private var userTapGestureRecognizer : UITapGestureRecognizer!
    private lazy var importancyMark : UIView = {
        let view = UIView(frame: CGRect(x: containerView.frame.origin.x - 5, y: 0, width: 15, height: 15))
        view.backgroundColor = .red
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.masksToBounds = true
        return view
    }()
    var isImportant : Bool = false{
        didSet{
            if isImportant{
                makeImportantVisibility()
            } else{
                importancyMark.removeFromSuperview()
            }
        }
    }
    
    //MARK: Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 12
        senderAvatarImageView.layer.cornerRadius = senderAvatarImageView.frame.width / 2
        senderAvatarImageView.contentMode = .scaleAspectFit
        senderAvatarImageView.layer.masksToBounds = true
        containerView.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(_:)))
        userTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        senderAvatarImageView.addGestureRecognizer(userTapGestureRecognizer)
        containerView.addGestureRecognizer(messageLongPressGestureRecognizer)
    }
    
    func makeImportantVisibility(){
        containerView.addSubview(importancyMark)
    }
    
    //MARK: Gestures actions
    
    @objc private func tapGestureAction(_ gesture: UITapGestureRecognizer){
        delegate?.didTapUserImageView(in: self)
        print("TAPPED")
    }
    
    @objc private func longPressGestureAction(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .ended{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didSelectContextMenu(in: self)
        }
    }
}
