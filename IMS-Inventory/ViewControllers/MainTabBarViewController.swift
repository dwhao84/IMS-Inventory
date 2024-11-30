import UIKit
import ESTabBarController

class MainTabBarViewController: ESTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        self.view.overrideUserInterfaceStyle = .light
        self.view.backgroundColor = Colors.white
        tabBar.tintColor = Colors.IKEA_Blue
        tabBar.isTranslucent = true
        selectedIndex = 1
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        appearance.shadowColor = .clear
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupViewControllers() {
        let productListNC = createNavigationController(
            for: ProductListViewController(),
            title: "Racking Status",
            image: Images.server
        )
        
        let calculationNC = createNavigationController(
            for: CalculationViewController(),
            title: "Calculation",
            image: Images.calculation
        )
        
        let settingNC = createNavigationController(
            for: SettingViewController(),
            title: "Settings",
            image: Images.gear
        )
        
        setViewControllers(
            [productListNC, calculationNC, settingNC],
            animated: true
        )
    }
    
    private func createNavigationController(
        for viewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = ESTabBarItem(
            CustomAnimatedTabBarContentView(),
            title: title,
            image: image,
            selectedImage: image
        )
        return navigationController
    }
}

// MARK: - Scene Delegate Setup Extension
extension MainTabBarViewController {
    static func createMainTabBar(for windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = MainTabBarViewController()
        return window
    }
}

// MARK: - Custom TabBar Content View
class CustomAnimatedTabBarContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        textColor = .systemGray2
        iconColor = .systemGray2
        highlightTextColor = Colors.black
        highlightIconColor = Colors.black
        backgroundColor = .clear
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

#Preview {
    MainTabBarViewController()
}
