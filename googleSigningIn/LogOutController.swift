//
//  LogOutController.swift
//  googleSigningIn
//
//  Created by Andrey Rybalkin on 20.03.2023.
//

import UIKit
import Firebase
import GoogleSignIn

class LogOutController: UIViewController, GIDSignInDelegate {
    // Создать кнопку выхода из системы
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Добавить кнопку на экран
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Установить делегата для Google Sign-In
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    // Обработчик нажатия на кнопку выхода из системы
    @objc func logoutButtonPressed() {
        do {
            // Выполнить выход из Google
            try Auth.auth().signOut()
            
            // Очистить данные пользователя и перенаправить на страницу входа
            UserDefaults.standard.set(nil, forKey: "userEmail") // Очистить данные пользователя из UserDefaults
            GIDSignIn.sharedInstance()?.signOut()
            let loginViewController = AuthViewController()
            navigationController?.pushViewController(loginViewController, animated: true) // Перенаправить на страницу входа
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // Реализовать метод делегата для Google Sign-In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error signing in with Google: \(error.localizedDescription)")
            return
        }
        
        guard let email = user.profile.email else {
            print("Error getting user email from Google")
            return
        }
        
        // Сохранить email пользователя в UserDefaults
        UserDefaults.standard.set(email, forKey: "userEmail")
    }
}
