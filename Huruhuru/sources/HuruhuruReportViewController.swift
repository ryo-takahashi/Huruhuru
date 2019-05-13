import UIKit

class HuruhuruReportViewController: UIViewController {
    @IBOutlet private weak var issueTitleField: UITextField!
    @IBOutlet private weak var issueDescriptionField: UITextField!

    @IBAction func didTapSendButton(_ sender: UIButton) {
        let issueTitle = issueTitleField.text ?? ""
        let issueDescription = issueDescriptionField.text ?? ""
        // githubにリクエスト送る
        // CreateIssueRequest(title: issueTitle, description: issueDescription)
        
        // 画面を閉じる
    }
    
}
