import UIKit
import FirebaseMessaging
import UserNotifications
import Firebase
import FirebaseAppCheck
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    private var fcmToken: String?
    private var deviceToken: String?
    
    // MARK: - Application Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase 必須最先配置
        if FirebaseApp.app() == nil {
            setupFirebase()
        }
        setupNotifications(application)
        setupKeyboardManager()
        Messaging.messaging().delegate = self
        // 延遲2秒後測試通知
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.testNotifications()
        }
        
        return true
    }
    
    // MARK: - Setup Methods
    private func setupFirebase() {
        // 配置 App Check
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        print("DEBUG: App Check configured with Debug Provider")
        #else
        let providerFactory = AppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        print("RELEASE: App Check configured with Device Check Provider")
        #endif
        
        // 配置 Firebase
        FirebaseApp.configure()
        print("Firebase configured successfully")
    }
    
    private func setupNotifications(_ application: UIApplication) {
        // Push notification setup
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
                return
            }
            print("Notification authorization granted: \(granted)")
            
            // 取得目前的通知設定
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("通知設定狀態：")
                print("授權狀態: \(settings.authorizationStatus.rawValue)")
                print("警示設定: \(settings.alertSetting)")
                print("聲音設定: \(settings.soundSetting)")
                print("角標設定: \(settings.badgeSetting)")
            }
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        Messaging.messaging().isAutoInitEnabled = true
    }
    
    private func setupKeyboardManager() {
        IQKeyboardManager.shared.isEnabled = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        print("Keyboard Manager configured successfully")
    }
    
    // MARK: - Notification Test Methods
    private func testNotifications() {
        sendLocalNotification()
        checkFCMToken()
    }
    
    private func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "測試通知"
        content.body = "這是一則本地測試通知"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "localTest", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("發送本地通知失敗: \(error.localizedDescription)")
            } else {
                print("本地通知已排程，將在5秒後發送")
            }
        }
    }
    
    private func checkFCMToken() {
        if let token = Messaging.messaging().fcmToken {
            print("目前的 FCM Token: \(token)")
            UserDefaults.standard.set(token, forKey: "FCMToken")
            self.fcmToken = token
        } else {
            print("FCM Token 尚未取得")
        }
    }
    
    // MARK: - Remote Notification Handling
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        self.deviceToken = token
        print("成功獲得 APNs device token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("註冊推播失敗，錯誤：\(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("收到遠端通知：\(userInfo)")
        
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        completionHandler(.newData)
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

// MARK: - UNUserNotificationCenter Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print("收到前台通知，內容：\(userInfo)")
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("收到通知回應，userInfo: \(userInfo)")
        
        // 處理通知點擊事件
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("用戶點擊通知")
        case UNNotificationDismissActionIdentifier:
            print("用戶關閉通知")
        default:
            print("其他動作: \(response.actionIdentifier)")
        }
        
        completionHandler()
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            print("FCM Token 為空")
            return
        }
        
        self.fcmToken = fcmToken
        print("收到新的 FCM Token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
        
        // 儲存 token 到本地或發送到伺服器
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}
