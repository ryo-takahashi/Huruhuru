import UIKit

public class Huruhuru {
    
    public static let shared = Huruhuru()
    private init() {}
    private var repositoryInfo: WriteToRepositoryInfo!
    private var token: GithubToken!
    
    public func start(writeToInfo: WriteToRepositoryInfo, token: GithubToken) {
        self.repositoryInfo = writeToInfo
        self.token = token
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(type(of: self).didTakeScreenShot(_:)),
                         name: UIApplication.userDidTakeScreenshotNotification,
                         object: nil)
    }
    
    deinit {
        NotificationCenter.default
            .removeObserver(self,
                            name: UIApplication.userDidTakeScreenshotNotification,
                            object: nil)
    }
    
    @objc private func didTakeScreenShot(_ notification: Notification) {
        presentReportController()
    }
    
    private func presentReportController() {
        guard let token = token.token else {
            assertionFailure("need set github token")
            return
        }
        let viewController = HuruhuruReportViewController()
        viewController.inject(ownerName: repositoryInfo.ownerName, repositoryName: repositoryInfo.repositoryName, accessToken: token)
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
        public let token: String?
        public init(token: String?) {
            self.token = token
        }
    }
}
