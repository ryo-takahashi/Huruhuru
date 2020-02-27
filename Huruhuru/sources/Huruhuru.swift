import UIKit

public class Huruhuru {
    
    public static let shared = Huruhuru()
    static let imageUploadBranchName = "huruhuru-auto-created-branch-for-upload-image"
    
    private init() {}
    private var repositoryInfo = RepositoryInfo(ownerName: "", repositoryName: "")
    private var token = GithubToken(token: nil)
    private var supportDetectGesture = SupportDetectGesture(types: [])
    private let githubClient = GithubClient()
    
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
        createBranchForImageUploadIfNeeded(ownerName: sendTo.ownerName, repositoryName: sendTo.repositoryName, accessToken: token.token ?? "")
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
        guard let currentPresentedViewController = fetchCurrentPresentedViewController() else {
            return
        }
        if let navigationController = currentPresentedViewController as? UINavigationController {
            if navigationController.topViewController is HuruhuruReportViewController {
                return
            }
        }
        let viewController = HuruhuruReportViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        let screenImage = currentPresentedViewController.view.asImage()
        viewController.inject(ownerName: repositoryInfo.ownerName, repositoryName: repositoryInfo.repositoryName, accessToken: token, uploadScreenImage: screenImage)
        currentPresentedViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func createBranchForImageUploadIfNeeded(ownerName: String, repositoryName: String, accessToken: String) {
        githubClient.send(request: SingleReferenceRequest(parameter: SingleReferenceRequest.Parameter(ownerName: ownerName, repositoryName: repositoryName, accessToken: accessToken, reference: "/heads/\(Self.imageUploadBranchName)")), completion: { [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                self?.githubClient.send(request: SingleReferenceRequest(parameter: SingleReferenceRequest.Parameter(ownerName: ownerName, repositoryName: repositoryName, accessToken: accessToken, reference: "/heads/master")), completion: { [weak self] result in
                    switch result {
                    case .success(let masterReference):
                        self?.githubClient.send(request: CreateReferenceRequest(parameter: CreateReferenceRequest.Parameter(ownerName: ownerName, repositoryName: repositoryName, accessToken: accessToken, body: CreateReferenceRequest.Body(ref: "refs/heads/\(Self.imageUploadBranchName)", sha: masterReference.object.sha))), completion: { _ in })
                    case .failure: break
                    }
                })
            }
        })
    }
    
    private func fetchCurrentPresentedViewController() -> UIViewController? {
        var viewController = UIApplication.shared.keyWindow?.rootViewController
        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController
        }
        return viewController
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
