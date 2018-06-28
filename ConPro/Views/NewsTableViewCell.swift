import UIKit

class NewsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var newsHeader: UILabel!
    @IBOutlet weak var newsMessage: UILabel!
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var dateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
