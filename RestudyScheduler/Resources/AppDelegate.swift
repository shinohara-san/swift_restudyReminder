//
//  AppDelegate.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/15.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift
//import AnimatedTabBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    var window: UIWindow?
    
//    fileprivate var items:[AnimatedTabBarItem] = {
//        var items = [AnimatedTabBarItem]()
//
//        let firstItem = AnimatedTabBarItem(icon: #imageLiteral(resourceName: "home"), title: "入力", controller: InputViewController())
//        let secondItem = AnimatedTabBarItem(icon: #imageLiteral(resourceName: "thunder"), title: "カレンダー", controller: ListViewController())
//        let thirdItem = AnimatedTabBarItem(icon: #imageLiteral(resourceName: "home"), title: "アプリ", controller: OtherViewController())
//
//        let itemArray = [firstItem, secondItem, thirdItem]
//        for item in itemArray{
//            items.append(item)
//        }
//        return items
//    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let tabBar = AnimatedTabBarController()
//        tabBar.delegate = self
//        window = UIWindow()
//        window?.rootViewController = tabBar
//        window?.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {(granted, error) in
            if granted {
                print("許可する")
            } else {
                print("許可しない")
            }
        }
        
        let config = Realm.Configuration(schemaVersion: 3)
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let realm = try! Realm()
//        let comp = 
        let today = Calendar.current.date(byAdding: .hour, value: 9, to: Date())
        let todayString = DatabaseManager.shared.stringFromDate(date: today!, format: "yyyy/MM/dd")
//        print(today!)
//        print(todayString)
        let studies = realm.objects(Study.self).filter("firstDay = '\(todayString)' OR secondDay = '\(todayString)' OR thirdDay = '\(todayString)' OR fourthDay = '\(todayString)' OR fifthDay = '\(todayString)'")
        let array = Array(studies)
//        print("studiesの中身: \(studies)")
//        print("arrayの中身: \(array)")
        switch array.count{
        case 0:
            setLocalNotification(title:"今日の復習はありません。", message:"勉強しよう！")
        default:
            setLocalNotification(title:"今日も復習しましょう！", message:"今日は\(array.count)科目です。")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func setLocalNotification(title:String, message:String, hour:Int = 9, minute:Int = 0, second:Int = 0 ){
    // タイトル、本文、サウンド設定の保持
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = message
    content.sound = UNNotificationSound.default
    
    var notificationTime = DateComponents()
    notificationTime.hour = hour
    notificationTime.minute = minute
    notificationTime.second = second
    
    let trigger: UNNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
    
    // 識別子とともに通知の表示内容とトリガーをrequestに内包
    let request = UNNotificationRequest(identifier: "restudy_notification", content: content, trigger: trigger)
    
    // UNUserNotificationCenterにrequestを加える
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    center.add(request) { (error) in
        if let error = error {
            print(error.localizedDescription)
        }
    }
}}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // アプリ起動中でもアラートと音で通知
        completionHandler([.alert, .sound])
    }
}

//extension AppDelegate: AnimatedTabBarDelegate{
//    func tabBar(_ tabBar: AnimatedTabBar, itemFor index: Int) -> AnimatedTabBarItem {
//        return items[index]
//    }
//
//    func initialIndex(_ tabBar: AnimatedTabBar) -> Int? {
//        return 0
//    }
//
//    var numberOfItems: Int{
//        return items.count
//    }
//}
