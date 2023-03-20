//
//  SingInViewController.swift
//  googleSigningIn
//
//  Created by Andrey Rybalkin on 20.03.2023.
//

import Foundation
import UIKit
import GoogleSignIn
import Firebase

// https://swiftsenpai.com/development/google-sign-in-integration/

class AuthViewController: UIViewController, GIDSignInUIDelegate {

    let googleSignInButton = GIDSignInButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        view.backgroundColor = .white

        // Add Google Sign-In button to view
        view.addSubview(googleSignInButton)

        // Set up constraints for Google Sign-In button
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        googleSignInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        googleSignInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        // Set up Google sign-in delegate
//        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Check if user is already signed in with Google
//        if GIDSignIn.sharedInstance().currentUser != nil {
//            navigateToMainAppScreen()
//        }
    }

    func navigateToMainAppScreen() {
        // Navigate to main app screen
        let mainViewController = LogOutController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

extension AuthViewController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Google sign-in error: \(error.localizedDescription)")
            return
        }

        // Access user data through user.authentication object
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        // Authenticate with Firebase using Google credentials
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase authentication error: \(error.localizedDescription)")
                return
            }

            self.navigateToMainAppScreen()
        }
    }
}

