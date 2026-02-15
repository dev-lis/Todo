//
//  AppDelegate.swift
//  Todo
//
//  Created by Aleksandr Lis on 14.02.2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coordinator: Coordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ServiceLocatorConfiguration.configure()

        let window = UIWindow()

        let coordinator = AppCoordinator(window: window)
        coordinator.start()

        self.window = window
        self.coordinator = coordinator

        return true
    }
}
