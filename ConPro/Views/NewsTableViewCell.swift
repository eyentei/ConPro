import UIKit

class NewsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var newsHeader: UILabel!
    @IBOutlet weak var newsExposition: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
