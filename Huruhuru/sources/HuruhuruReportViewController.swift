import UIKit

class HuruhuruReportViewController: UIViewController {
    @IBOutlet private weak var issueTitleField: UITextField!
    @IBOutlet private weak var issueDescriptionField: UITextField!
    
    private var ownerName: String!
    private var repositoryName: String!
    private var accessToken: String?
    
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
            print("create issue done!")
        }
        dismiss(animated: true, completion: nil)
    }
    
}
