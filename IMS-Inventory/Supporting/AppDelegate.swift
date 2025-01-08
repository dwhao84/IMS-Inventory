//
//  AppDelegate.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/8.
//

//
//  AppDelegate.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2023/11/8.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var authStateHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Application Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupFirebase()
        setupKeyboardManager()
        setupAuthStateListener()
        setupPushNotifications(application)
        return true
    }
    
    // MARK: - Setup Methods
    
    private func setupFirebase() {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.error)
    }
    
    private func setupKeyboardManager() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    
    private func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("=== User is signIn ===")
                print("User ID: \(user.uid)")
                // 可以在這裡處理用戶登入後的其他邏輯
            } else {
                print("=== User is signOut ===")
                // 可以在這裡處理用戶登出後的其他邏輯
            }
        }
    }
    
    private func setupPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions) { granted, error in
                if let error = error {
                    print("推播通知授權失敗: \(error.localizedDescription)")
                    return
                }
                
                if granted {
                    print("使用者已允許推播通知")
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    print("使用者拒絕推播通知")
                }
            }
    }
    
    // MARK: - UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // 當場景被丟棄時釋放相關資源
    }
    
    // MARK: - Push Notification Registration
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("註冊推播失敗: \(error.localizedDescription)")
    }
    
    // MARK: - Memory Management
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 當應用程式在前景時收到通知
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // 處理使用者點擊通知的事件
        let userInfo = response.notification.request.content.userInfo
        print("使用者點擊通知: \(userInfo)")
        completionHandler()
    }
}
