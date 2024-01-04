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
        tabBarController.selectedIndex = 2
        tabBarController.delegate = self

        tabBarController.tabBar.tintColor = SystemColor.blueColor

        let appearance = tabBarController.tabBarItem.scrollEdgeAppearance
        tabBarController.tabBarItem.scrollEdgeAppearance = appearance

        let productListVC:  UIViewController = ProductListViewController()
        let shoppingListVC: UIViewController = ShoppingListViewController()
        let homePageVC:     UIViewController = HomePageViewController()

        homePageVC.tabBarItem = UITabBarItem(title: "首頁", image: UIImage(systemName: "house", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)), tag: 2)

        productListVC.tabBarItem = UITabBarItem(title: "品項庫存", image: UIImage(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)), tag: 0)

        shoppingListVC.tabBarItem = UITabBarItem(title: "預約清單", image: UIImage(systemName: "bag.badge.plus", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)), tag: 1)


        tabBarController.setViewControllers([homePageVC, productListVC, shoppingListVC], animated: false)

        window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
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
