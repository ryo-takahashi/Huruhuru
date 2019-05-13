import UIKit

public class Huruhuru {
    
    private let repositoryInfo: WriteToRepositoryInfo
    private let token: GithubToken
    
    public init(writeToInfo: WriteToRepositoryInfo, token: GithubToken) {
        self.repositoryInfo = writeToInfo
        self.token = token
    }
    
    public func start() {
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.detectedScreenShot()
        }
    }
    
    private func detectedScreenShot() {
        print("take screenshot")
        presentReportController()
    }
    
    private func presentReportController() {
        let viewController = HuruhuruReportViewController()
        UIApplication.shared.delegate?.window??.rootViewController?.present(viewController, animated: true, completion: nil)
    }
}

extension Huruhuru {
    public struct WriteToRepositoryInfo {
        public let ownerName: String
        public let repositoryName: String
        
        public init(ownerName: String, repositoryName: String) {
            self.ownerName = ownerName
            self.repositoryName = repositoryName
        }
    }
    public struct GithubToken {
        public let token: String
        public init(token: String) {
            self.token = token
        }
    }
}
