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
        self.view.overrideUserInterfaceStyle = .light
        
        // 使用系統材質效果
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        // 設置背景效果
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

        // 設置背景顏色（半透明效果）
        appearance.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        // 移除上方邊框線
        appearance.shadowColor = .clear
        
        // 套用外觀設置
        self.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = appearance
        }
        // 其他設置
        self.tabBar.tintColor = Colors.IKEA_Blue
        self.tabBar.isTranslucent = true
        
        // 設置默認選中的頁面
        self.selectedIndex = 1
    }
    
    private func setupViewControllers() {
        let productListNC = createProductListNC()
        let settingNC = createSettingNC()
        let calculationNC = createCalculationNC()
        
        productListNC.tabBarItem = ESTabBarItem.init(
            CustomAnimatedTabBarContentView(),
            title: "Racking Status",
            image: Images.list_bullet,
            selectedImage: Images.list_bullet
        )
        
        calculationNC.tabBarItem = ESTabBarItem.init(
            CustomAnimatedTabBarContentView(),
            title: "Calculation",
            image: Images.keyboard,
            selectedImage: Images.keyboard
        )
        
        settingNC.tabBarItem = ESTabBarItem.init(
            CustomAnimatedTabBarContentView(),
            title: "Settings",
            image: Images.gear,
            selectedImage: Images.gear
        )
        
        setViewControllers(
            [productListNC, calculationNC, settingNC],
            animated: true
        )
    }
    
    // **MARK: - Navigation Controllers Creation**
    private func createProductListNC() -> UINavigationController {
        let productListVC = ProductListViewController()
        let productListNC = UINavigationController(rootViewController: productListVC)
        return productListNC
    }
    
    private func createCalculationNC() -> UINavigationController {
        let calculationVC = CalculationViewController()
        let calculationNC = UINavigationController(rootViewController: calculationVC)
        return calculationNC
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
        // 未選中狀態的顏色
        textColor = .systemGray2
        iconColor = .systemGray2
        
        // 選中狀態的顏色
        highlightTextColor = Colors.black
        highlightIconColor = Colors.black
        
        // 背景顏色設為透明
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
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
