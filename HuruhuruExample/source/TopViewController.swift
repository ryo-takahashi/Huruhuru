import UIKit
import Huruhuru

class TopViewController: UIViewController {
    @IBAction func tappedProfileButton(_ sender: UIButton) {
        guard let viewController = UIStoryboard(name: "ExampleViewController", bundle: nil).instantiateInitialViewController() else { return }
        present(viewController, animated: true, completion: nil)
    }
}
