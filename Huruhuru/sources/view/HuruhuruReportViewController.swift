import UIKit

class HuruhuruReportViewController: UIViewController {
    @IBOutlet private weak var issueTitleField: UITextField!
    @IBOutlet private weak var issueDescriptionField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var screenImageView: UIImageView!
    @IBOutlet private weak var loadingView: UIView!
    
    private var ownerName: String!
    private var repositoryName: String!
    private var accessToken: String!
    private var uploadScreenImage: UIImage!
    private let githubClient = GithubClient()
    
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
        screenImageView.image = uploadScreenImage
        issueTitleField.delegate = self
        issueDescriptionField.delegate = self
    }
    
    func inject(ownerName: String, repositoryName: String, accessToken: String, uploadScreenImage: UIImage) {
        self.ownerName = ownerName
        self.repositoryName = repositoryName
        self.accessToken = accessToken
        self.uploadScreenImage = uploadScreenImage
    }

    @IBAction func didTapSendButton(_ sender: UIButton) {
        guard let issueTitle = issueTitleField.text, let uploadScreenImageData = uploadScreenImage.resize(width: 400)?.pngData() else { return }
        let issueDescription = issueDescriptionField.text ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let currentDateString = formatter.string(from: Date())
        let fileName = "\(issueTitle.removedSpacing)-\(currentDateString).png"
        let createFileRequestParameter = CreateFileRequest.Parameter(ownerName: ownerName, repositoryName: repositoryName, accessToken: accessToken, fileName: fileName, body: CreateFileRequest.Body(message: fileName, content: uploadScreenImageData.base64EncodedString(), branch: Huruhuru.imageUploadBranchName))
        loadingView.isHidden = false
        githubClient.send(request: CreateFileRequest(parameter: createFileRequestParameter)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let issueDescription = self.generateIssueDescription(inputDescription: issueDescription, uploadedScreenImagePath: response.content.htmlURL)
                self.githubClient.send(request: CreateIssueRequest(ownerName: self.ownerName, repositoryName: self.repositoryName, title: issueTitle, body: issueDescription, accessToken: self.accessToken)) { [weak self] (result) in
                    DispatchQueue.main.async {
                        self?.loadingView.isHidden = true
                    }
                    switch result {
                    case .success:
                        self?.presentAlertViewController(title: "Successfully report issue! 🚀", message: nil)
                    case .failure(let error):
                        self?.presentAlertViewController(title: "error 🤢", message: error.message)
                    }
                }
            case .failure(let error):
                self.presentAlertViewController(title: "error 🤢", message: error.message)
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
    
    private func generateIssueDescription(inputDescription: String, uploadedScreenImagePath: String) -> String {
        return """
        ## Description
        \(inputDescription)
        
        ## Device Info
        \(fetchDeviceInfo())
        
        ## ScreenShot
        \(uploadedScreenImagePath)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        issueTitleField.resignFirstResponder()
        issueDescriptionField.resignFirstResponder()
    }
}

extension HuruhuruReportViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
