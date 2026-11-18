//
//  SceneDelegate.swift
//  StudentOrganizer
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // The window and the first screen are created automatically from Main.storyboard.
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save any unsaved Core Data changes so nothing is lost if iOS closes the app
        // while it is in the background.
        CoreDataStack.shared.save()
    }
}
