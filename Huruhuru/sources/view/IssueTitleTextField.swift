import UIKit

class IssueTitleTextField: UITextField {
    static let insetHorizontal: CGFloat = 10.0
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds.insetBy(dx: Self.insetHorizontal, dy: 0.0))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds.insetBy(dx: Self.insetHorizontal, dy: 0.0))
    }

}
