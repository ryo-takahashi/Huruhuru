import UIKit

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func setCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

    func setRoundedBorder(color: UIColor?, cornerRadius: CGFloat, width: CGFloat = 1.0) {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
        setCornerRadius(cornerRadius)
    }
}
