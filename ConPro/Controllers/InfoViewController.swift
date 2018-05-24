import UIKit

class InfoViewController: UIViewController {

    var selectedEvent: Event?
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var modalWindow: UIView!
    @IBAction func closeWindow(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        category.text = "Category: " + (selectedEvent?.eventCategory)!
        info.text = selectedEvent?.eventDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
