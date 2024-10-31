//
//  MainTabBarViewController.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/10/31.
//
import UIKit
import ESTabBarController

class MainTabBarViewController: ESTabBarController {
    
    // **MARK: - Life Cycle**
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    // **MARK: - Setup Methods**
    private func setupTabBar() {
        self.tabBar.backgroundColor = Colors.CustomBackgroundColor
        self.tabBar.tintColor = Colors.IKEA_Blue
        // 設置默認選中的頁面
        self.selectedIndex = 1
    }
    
    private func setupViewControllers() {
        let productListNC = createProductListNC()
        let settingNC = createSettingNC()
        
        productListNC.tabBarItem = ESTabBarItem.init(
            CustomAnimatedTabBarContentView(),
            title: "Racking Status",
            image: Images.list_bullet,
            selectedImage: Images.list_bullet
        )
        
        settingNC.tabBarItem = ESTabBarItem.init(
            CustomAnimatedTabBarContentView(),
            title: "Settings",
            image: Images.gear,
            selectedImage: Images.gear
        )
        
        setViewControllers(
            [productListNC, settingNC],
            animated: true
        )
    }
    
    // **MARK: - Navigation Controllers Creation**
    private func createProductListNC() -> UINavigationController {
        let productListVC = ProductListViewController()
        let productListNC = UINavigationController(rootViewController: productListVC)
        return productListNC
    }
    
    private func createSettingNC() -> UINavigationController {
        let settingVC = SettingViewController()
        let settingNC = UINavigationController(rootViewController: settingVC)
        return settingNC
    }
}

// **MARK: - Custom TabBar Content View**
class CustomAnimatedTabBarContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = Colors.lightGray
        iconColor = Colors.lightGray
        highlightTextColor = Colors.IKEA_Blue
        highlightIconColor = Colors.IKEA_Blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        // 點擊時的動畫效果
        bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        // 重複點擊時的動畫效果
        bounceAnimation()
        completion?()
    }
    
    private func bounceAnimation() {
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}

// **MARK: - Scene Delegate Setup Extension**
extension MainTabBarViewController {
    static func createMainTabBar(for windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        
        let mainTabBarController = MainTabBarViewController()
        window.rootViewController = mainTabBarController
        
        return window
    }
}

#Preview {
    MainTabBarViewController()
}
