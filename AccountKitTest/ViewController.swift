//
//  ViewController.swift
//  AccountKitTest
//
//  Created by Jarrod Parkes on 8/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import AccountKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Properties
    
    // NOTE: If your app receives an authorization code that it will pass to the server (because the Enable Client Access Token Flow switch in your app's dashboard is OFF), it is up to you to have your server communicate the correct login status to your client application and return that in isUserLoggedIn.
    private var accountKit = AKFAccountKit(responseType: .authorizationCode)
    private var pendingLoginViewController: AKFViewController? = nil
    private var authorizationCode = false
    private var isUserLoggedIn = false
    
    fileprivate let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login with Phone", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 217.0 / 255.0, green: 57.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(ViewController.loginWithPhone), for: .touchUpInside)
        return button
    }()
    
    fileprivate let codeWillAppearLabel: UILabel = {
        let label = UILabel()
        label.text = "The AccountKit authorization code will appear below. With Universal Clipboard, you can copy and paste this code onto your development machine for testing."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    fileprivate let codeTextField: UITextView = {
        let textView = UITextView()
        textView.text = "[Authorization Code]"
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        return textView
    }()
    
    fileprivate let copyCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy to Clipboard", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 217.0 / 255.0, green: 57.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(ViewController.copyCodeToClipboard), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        
        pendingLoginViewController = accountKit.viewControllerForLoginResume() as? AKFViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isUserLoggedIn {
            // go to next screen...
            print("user logged in, go to next screen...")
        }
    }
    
    // MARK: AccountKit
    
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        loginViewController.delegate = self
    }
    
    @objc func loginWithPhone() {
        if let viewController = accountKit.viewControllerForPhoneLogin() as? AKFViewController {
            prepareLoginViewController(viewController)
            viewController.enableSendToFacebook = true
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Utility
    
    private func addSubviews() {
        view.addSubview(loginButton)
        view.addSubview(codeWillAppearLabel)
        view.addSubview(codeTextField)
        view.addSubview(copyCodeButton)
    }
    
    private func setupConstraints() {
        
        let views: [String: AnyObject] = [
            "loginButton": loginButton,
            "codeWillAppearLabel": codeWillAppearLabel,
            "codeTextField": codeTextField,
            "copyCodeButton": copyCodeButton,
            "topLayoutGuide": topLayoutGuide
        ]
        
        for value in views.values {
            if let view = value as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        
        let visualFormatConstraints = [
            "V:[topLayoutGuide]-20-[loginButton(50)]-10-[codeWillAppearLabel(100)]-10-[codeTextField]-10-[copyCodeButton(50)]-20-|",
            "H:|-[codeWillAppearLabel]-|",
            "H:|-[loginButton]-|",
            "H:|-[codeTextField]-|",
            "H:|-[copyCodeButton]-|"
        ]
        
        for visualFormatConstraint in visualFormatConstraints {
            let constaints = NSLayoutConstraint.constraints(withVisualFormat: visualFormatConstraint, options: NSLayoutFormatOptions(), metrics: nil, views: views)
            view.addConstraints(constaints)
        }
    }
    
    @objc func copyCodeToClipboard() {
        UIPasteboard.general.string = codeTextField.text
    }
}

// MARK: - ViewController: AKFViewControllerDelegate

extension ViewController: AKFViewControllerDelegate {
        
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String, state: String) {
        codeTextField.text = code
    }
    
    func viewController(_ viewController: UIViewController, didFailWithError error: Error!) {
        print("\(viewController) did fail with error: \(error)")
    }
    
    func viewControllerDidCancel(_ viewController: UIViewController) {
        print("\(viewController) did cancel")
    }
}
