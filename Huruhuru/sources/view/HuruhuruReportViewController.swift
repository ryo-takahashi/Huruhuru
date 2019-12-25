import UIKit

class HuruhuruReportViewController: UIViewController {
    @IBOutlet private weak var issueTitleField: UITextField!
    @IBOutlet private weak var issueDescriptionField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    
    private var ownerName: String!
    private var repositoryName: String!
    private var accessToken: String!
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        let bundle = Bundle(for: HuruhuruReportViewController.self)
        super.init(nibName: "HuruhuruReportViewController", bundle: bundle)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelBarButtonItem(_:)))
        navigationItem.rightBarButtonItem = cancelBarButtonItem
        navigationItem.title = "Huruhuru Report Issue"
        sendButton.isEnabled = false
    }
    
    func inject(ownerName: String, repositoryName: String, accessToken: String) {
        self.ownerName = ownerName
        self.repositoryName = repositoryName
        self.accessToken = accessToken
    }

    @IBAction func didTapSendButton(_ sender: UIButton) {
        guard let issueTitle = issueTitleField.text else { return }
        let issueDescription = generateIssueDescription(inputDescription: issueDescriptionField.text ?? "")
        GithubClient().send(request: CreateIssueRequest(ownerName: ownerName, repositoryName: repositoryName, title: issueTitle, body: issueDescription, accessToken: accessToken)) { [weak self] (result) in
            switch result {
            case .success:
                self?.presentAlertViewController(title: "Successfully report issue! 🚀", message: nil)
            case .failure(let error):
                switch error {
                case .apiError(let error):
                    self?.presentAlertViewController(title: "API Error 🙃", message: error.message)
                case .connectionError(let error):
                    self?.presentAlertViewController(title: "connection error 💥", message: error.localizedDescription)
                case .responseParseError(let error):
                    self?.presentAlertViewController(title: "response parse error 🤢", message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func didChangeIssueTitleTextField(_ sender: UITextField) {
        let isEnabledSendButton = sender.text != nil
        sendButton.isEnabled = isEnabledSendButton
    }
    
    @objc func didTapCancelBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func generateIssueDescription(inputDescription: String) -> String {
        return """
        ## Description
        \(inputDescription)
        
        ## Device Info
        \(fetchDeviceInfo())
        """
    }
    
    private func fetchDeviceInfo() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let reportedAt = formatter.string(from: Date())
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let deviceName = UIDevice.current.name
        let osName = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let osModelName = UIDevice.current.model
        let screenSize = "\(UIScreen.main.bounds.height)x\(UIScreen.main.bounds.width)"
        return """
        |key|value|
        |:--|:--|
        |Report Date|\(reportedAt)|
        |App Version|\(appVersion)|
        |Build Version|\(buildVersion)|
        |Device|\(deviceName) \(osName) \(osVersion) \(osModelName)|
        |Screen Size|\(screenSize)|
        """
    }
    
    private func presentAlertViewController(title: String, message: String?) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "閉じる", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(closeAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
