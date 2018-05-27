import UIKit
import AudioToolbox

class PersonalMessageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
    //MARK: Fields
    weak var delegate : ChatMessageDelegate?
    private var messageLongPressGestureRecognizer : UILongPressGestureRecognizer!
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
        containerView.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(_:)))
        containerView.addGestureRecognizer(messageLongPressGestureRecognizer)
    }
    
    private func makeImportantVisibility(){
        addSubview(importancyMark)
    }
    
    //MARK: Gestures actions
    @objc private func longPressGestureAction(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .ended{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didSelectContextMenu(in: self)
        }
    }
}
