import UIKit
import Huruhuru

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Huruhuru(writeToInfo: Huruhuru.WriteToRepositoryInfo(ownerName: "ryo-takahashi", repositoryName: "huruhuru") , token: Huruhuru.GithubToken(token: "")).start()
        return true
    }
}

