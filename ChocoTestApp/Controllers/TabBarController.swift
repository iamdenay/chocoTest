
import UIKit
import ChameleonFramework

fileprivate struct MainTabBarItem {
    var title: String?
    var icon: (UIImage?, UIImage?)
    var controller: UIViewController
}

class TabBarViewController: UITabBarController {
    
    fileprivate let tabBarItems = [
        MainTabBarItem(title: "Currencies", icon: (#imageLiteral(resourceName: "first"),#imageLiteral(resourceName: "first") ),
                       controller: RealtimeBPIViewController()),
        MainTabBarItem(title: "History", icon: ( #imageLiteral(resourceName: "first"), #imageLiteral(resourceName: "first")),
                       controller: TransactionsViewController()),
        MainTabBarItem(title: "Converter", icon: ( #imageLiteral(resourceName: "first"), #imageLiteral(resourceName: "first")),
                       controller: ConverterViewController())
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configAppBar()
    }
    
    fileprivate func configAppBar(){
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        UINavigationBar.appearance().layer.shadowRadius = 0.5
        UINavigationBar.appearance().layer.shadowOffset = CGSize(width: 0, height: 0.0)
        UINavigationBar.appearance().isTranslucent = false
        view.backgroundColor = Settings.bgColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    fileprivate func configureTabBarItem(_ tabBarItem: UITabBarItem?, title: String?,
                                         image: UIImage?, selectedImage: UIImage?) {
        tabBarItem?.title = title
        tabBarItem?.image = image
        tabBarItem?.selectedImage = selectedImage
    }
    
    func configureTabBar() {
        viewControllers = tabBarItems.compactMap { item in
            let nc = UINavigationController(rootViewController: item.controller)
            
            return nc
        }
        
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
        tabBar.barTintColor = .flatBlackDark
        
        for (index, item) in tabBarItems.enumerated() {
            configureTabBarItem(tabBar.items![index],
                                title: item.title,
                                image: item.icon.0,
                                selectedImage: item.icon.1)
        }
    }
    
}


