//
//  AppDelegate.swift
//  TripDo
//
//  Created by 요한 on 2020/07/31.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UINavigationController(rootViewController: ViewController())
    window?.makeKeyAndVisible()
    FirebaseApp.configure()
    Thread.sleep(forTimeInterval: 0.4)
    
    return true
  }
  
  // MARK: - CoreData
  lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "UserInfo")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error {
              fatalError("Unresolved error, \((error as NSError).userInfo)")
          }
      })
      return container
  }()
}

