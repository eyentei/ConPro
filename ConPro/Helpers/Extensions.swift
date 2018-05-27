import Foundation
import UIKit

extension String {
    func isEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
extension UIViewController {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
}

extension Date {
    init?(date: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        guard let date = formatter.date(from: date) else {
            return nil
        }
        self = date
    }
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}

extension UIImage {
    var data: Data? {
        return UIImagePNGRepresentation(self)
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
            let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw(in: CGRect(origin: .zero, size: canvasSize))
            return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension Data {
    var image: UIImage? {
        return UIImage(data: self)
    }
}
