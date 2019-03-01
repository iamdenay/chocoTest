
import UIKit
import Sugar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.backgroundColor = .white
        }
        
        let vc = TabBarViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
}

