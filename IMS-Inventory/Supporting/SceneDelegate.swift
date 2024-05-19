//
//  SceneDelegate.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/8.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene

        let tabBarController: UITabBarController = UITabBarController()
        tabBarController.setViewControllers(
            [
                createHomePageNC(),
                createProductListNC()
            ],
            animated: true
        )
        window?.rootViewController = tabBarController
        tabBarController.selectedIndex = 1
        self.window?.makeKeyAndVisible()
    }
    
    func createProductListNC () -> UINavigationController {
        let productListVC: UIViewController = ProductListViewController()
        let productListNC: UINavigationController = UINavigationController(rootViewController: productListVC)
        productListNC.tabBarItem.image = UIImage(systemName: "list.bullet")
        productListNC.tabBarItem.title = "品項庫存"
        return productListNC
    }
    
    func createHomePageNC () -> UINavigationController {
        let homePageVC: UIViewController = HomePageViewController()
        let homePageNC: UINavigationController = UINavigationController(rootViewController: homePageVC)
        homePageNC.tabBarItem.image = UIImage(systemName: "house")
        homePageNC.tabBarItem.title = "首頁"
        return homePageNC
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate: UITabBarControllerDelegate {

}
