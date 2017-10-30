//
//  ViewController.swift
//  CACproject
//
//  Created by Timothy Park on 10/16/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit
import TextFieldEffects
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class ViewController: UIViewController, GIDSignInUIDelegate {

    //username.text is actually email
    @IBOutlet weak var usernameName: JiroTextField!
    @IBOutlet weak var passwordName: JiroTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        //more google sign-in stuff
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
        //add gesture regcognizer
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        var usernameFrame = usernameName.frame
        var passwordFrame = passwordName.frame
        
        usernameFrame.size.height = 42
        usernameFrame.size.width = 254
        passwordFrame.size.height = 42
        passwordFrame.size.width = 254
        
        //center username and password
        usernameName.center.x = view.center.x
        passwordName.center.x = view.center.x
        
        //usernameName.center.y = view.center.y - 30
        
        setupLabels()
        
        //tap gesture to exit keyboard
        //let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        
        /*
        loginButton = UIButton(type: .system)
        loginButton.backgroundColor = UIColor(red: 89/255, green: 89/255, blue: 89/255, alpha: 1.0)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        */
        initializeView()
        self.view.addSubview(loginButton)
        
        //this is supposed to be a function
        //googleButton.frame.size = CGSize(width: 375, height: 56)
        //googleButton.center.x = view.center.x
        //googleButton.colorScheme = GIDSignInButtonColorScheme.dark
        //googleButton.centerYAnchor.constraint(equalTo: forgotPasswordButton.centerYAnchor, constant: -30)
        //googleButton.layer.cornerRadius = 10
        //googleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        
        //More google login stuff
        self.googleButton.colorScheme = GIDSignInButtonColorScheme.dark
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        
        //view.addGestureRecognizer(tap)
        //self.view.addSubview(usernameName)
        //self.view.addSubview(passwordName)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    deinit {
        self.view.removeFromSuperview()
    }
    
    @IBAction func didRequestPasswordReset(_ sender: Any) {
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        loginButton.pulsate()
        if let email = usernameName.text, let password = passwordName.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                print("User has successfully logged in!")
                
                /*
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let moveToTabBar = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = moveToTabBar
                */
                
                let interMedLogin = intermediateViewController()
                self.navigationController?.pushViewController(interMedLogin, animated: true)
                
                //present mainVC from the login view controller
                //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
                //vc.performSegue(withIdentifier: "SegueFromLeft", sender: self.loginButton)
                //vc.prepare(for: nil, sender: nil)
            })
        }
    }
    
    func setupLabels() {
        //loginButton Properties
        loginButton.center.x = view.center.x
        loginButton.frame.size = CGSize(width: 171, height: 38)
        loginButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        
        //createAccountButton properties
        createAccountButton.center.x = view.center.x
        createAccountButton.frame.size = CGSize(width: 123, height: 30)
        createAccountButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        //createAccountButton.layer.cornerRadius = 20
        createAccountButton.clipsToBounds = true
        
        //forgotPasswordButton properties
        forgotPasswordButton.center.x = view.center.x
        forgotPasswordButton.frame.size = CGSize(width: 130, height: 32)
        forgotPasswordButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 13)
        forgotPasswordButton.clipsToBounds = true
    }
    
    @IBAction func prepareForUnwind (segue: UIStoryboardSegue) {
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let segue = unwindScaleSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
    }
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        usernameName.resignFirstResponder()
        passwordName.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initializeView() {
        //view.backgroundColor = UIColor(red: 114/255, green: 54/255, blue: 128/255, alpha: 0.8)
        
        //usernameName.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: usernameName, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        usernameName.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0)
        usernameName.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10)
        //passwordName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        passwordName.centerYAnchor.constraint(equalTo: usernameName.centerYAnchor, constant: -45).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: passwordName.centerYAnchor, constant: -30).isActive = true
        
        createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccountButton.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor, constant: -20).isActive = true
        
        forgotPasswordButton.centerYAnchor.constraint(equalTo: createAccountButton.centerYAnchor, constant: -16)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 0.8
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}





