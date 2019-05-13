import UIKit

class HuruhuruReportViewController: UIViewController {
    @IBOutlet private weak var issueTitleField: UITextField!
    @IBOutlet private weak var issueDescriptionField: UITextField!
    
    private var ownerName: String!
    private var repositoryName: String!
    private var accessToken: String?
    
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
    
    func inject(ownerName: String, repositoryName: String, accessToken: String?) {
        self.ownerName = ownerName
        self.repositoryName = repositoryName
        self.accessToken = accessToken
    }

    @IBAction func didTapSendButton(_ sender: UIButton) {
        let issueTitle = issueTitleField.text ?? ""
        let issueDescription = issueDescriptionField.text ?? ""
        GithubClient().send(request: CreateIssueRequest(ownerName: ownerName, repositoryName: repositoryName, title: issueTitle, body: issueDescription, accessToken: accessToken)) { (result) in
            guard let response = try? result.get() else { return }
        }
        dismiss(animated: true, completion: nil)
    }
    
}
