extension UIImage {
    func resize(width: Double) -> UIImage? {
        let aspectScale = self.size.height / self.size.width
        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
        UIGraphicsBeginImageContext(resizedSize)
        self.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
