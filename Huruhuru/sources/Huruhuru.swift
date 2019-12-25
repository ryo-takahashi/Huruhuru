import UIKit

public class Huruhuru {
    
    public static let shared = Huruhuru()
    private init() {}
    private var repositoryInfo: RepositoryInfo!
    private var token: GithubToken!
    private var supportDetectGesture: SupportDetectGesture!
    
    public func start(sendTo: RepositoryInfo, token: GithubToken, supportDetectGesture: SupportDetectGesture) {
        self.repositoryInfo = sendTo
        self.token = token
        self.supportDetectGesture = supportDetectGesture
        
        if supportDetectGesture.fetchDetectEnabledState(detectType: .screenshot) {
            NotificationCenter.default
                .addObserver(self,
                             selector: #selector(type(of: self).didTakeScreenShot(_:)),
                             name: UIApplication.userDidTakeScreenshotNotification,
                             object: nil)
        }
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
    
    fileprivate func didShakeMotion() {
        if supportDetectGesture.fetchDetectEnabledState(detectType: .shake) {
            presentReportController()
        }
    }
    
    private func presentReportController() {
        guard let token = token.token else {
            assertionFailure("need set github token")
            return
        }
        guard let screenImage = UIApplication.shared.keyWindow?.rootViewController?.view.asImage()else {
            return
        }
        let viewController = HuruhuruReportViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.inject(ownerName: repositoryInfo.ownerName, repositoryName: repositoryInfo.repositoryName, accessToken: token, uploadScreenImage: screenImage)
        UIApplication.shared.delegate?.window??.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}

extension Huruhuru {
    public struct RepositoryInfo {
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
    
    public struct SupportDetectGesture {
        public enum DetectType {
            case screenshot
            case shake
        }
        
        public let types: [DetectType]
        
        public init(types: [DetectType]) {
            self.types = types
        }
        
        public func fetchDetectEnabledState(detectType: DetectType) -> Bool {
            let isEnabledDetectType = !types.lazy.filter { $0 == detectType }.isEmpty
            return isEnabledDetectType
        }
    }
    
}

extension UIViewController {
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        if motion == .motionShake {
            Huruhuru.shared.didShakeMotion()
        }
    }
}
