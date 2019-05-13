import UIKit

public class Huruhuru {
    
    public init() {}
    
    public func start() {
        print("start!")
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.detectedScreenShot()
        }
    }
    
    private func detectedScreenShot() {
        print("take screenshot")
    }
}
