//
//  AppDelegate.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let questionController = QuestionsController.getQuestionsController()
        window?.rootViewController = UINavigationController(rootViewController: questionController)
        window?.makeKeyAndVisible()
        return true
    }

}

