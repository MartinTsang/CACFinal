//
//  CreateAccountController.swift
//  CACproject
//
//  Created by Timothy Park on 10/16/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class CreateAccountController: UIViewController {

    @IBOutlet weak var usernameName: JiroTextField!
    @IBOutlet weak var emailAddressName: JiroTextField!
    @IBOutlet weak var passwordName: JiroTextField!
    
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var cancelCreating: UIButton!
    
    //let testButton: UIButton = UIButton()
    
    @IBAction func formNewAccount(_ sender: Any) {
        createAccount.pulsate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var usernameFrame = usernameName.frame
        //var passwordFrame = passwordName.frame
        //var emailAddressFrame = emailAddressName.frame
        
        initializeView()
        //view.addSubview(testButton)
        
//        testButton.backgroundColor = UIColor.black
//        testButton.setTitle("Hi", for: .normal)
//        testButton.translatesAutoresizingMaskIntoConstraints = false
//
//        testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        testButton.centerYAnchor.constraint(equalTo: usernameName.centerYAnchor, constant: 20).isActive = true
//        testButton.addTarget(self, action: #selector(moveToIntermediate), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        createAccount.pulsate()
        guard let email = emailAddressName.text, let password = passwordName.text, let username = usernameName.text else {
            print("Not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                print("User has successfully created an account!")
            
            guard let uid = user?.uid else {
                return
            }
            
            
                var ref: DatabaseReference!
                ref = Database.database().reference(fromURL: "https://cacproject-4a46d.firebaseio.com/")
                let usersReference = ref.child("users").child(uid)
                let values = ["name": username, "email": email]
                usersReference.updateChildValues(values, withCompletionBlock: {(error, ref) in
                    
                    if error != nil {
                        print (error as Any)
                        return
                    }
                    
                    print("Saved User Successfully into Firebase Database")
                })
            
            //different ways of presenting
                //present mainVC from CreateAccountController
                //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
                //vc.performSegue(withIdentifier: "SegueFromLeft", sender: self.createAccount)
                //vc.prepare(for: nil, sender: nil)
            //or pushing --> self.navigationController.pushViewController(name, animaged: true)
            
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let moveToTabBar = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = moveToTabBar
            
            
            let label3: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(label3)
            label3.translatesAutoresizingMaskIntoConstraints = false
            
            label3.font = UIFont.boldSystemFont(ofSize: 12)
            label3.textColor = UIColor.red
            self.view.addConstraint(NSLayoutConstraint(item: label3, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            
            self.view.addConstraint(NSLayoutConstraint(item: label3, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            label3.text = "Successfully created Account!"
            label3.fadeIn()
            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let moveToIntermediate = storyboard.instantiateViewController(withIdentifier: "intermediate")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = moveToIntermediate
            
 
//            let interMed = intermediateViewController()
//            interMed.modalTransitionStyle = .crossDissolve
//            interMed.view.layer.speed = 0.3
//            self.present(interMed, animated: true, completion: nil)

    
                //vc.popupviewcontroller
                //vc.present
                //vc.showviewcontroller
                //or you can use segue on main.storyboard
                
            })
        }

    @objc func moveToIntermediate() {
        
        performSegue(withIdentifier: "toTabView", sender: nil)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moveToIntermediate = storyboard.instantiateViewController(withIdentifier: "interMed")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = moveToIntermediate
        
        
//        let interMediate = intermediateViewController()
//        interMediate.modalTransitionStyle = .crossDissolve
//        interMediate.view.layer.speed = 0.2
//        print("ur ok")
//        self.present(interMediate, animated: true, completion: nil)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func initializeView() {
        
        //self.view.addConstraint(NSLayoutConstraint(item: usernameName, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        //self.view.addConstraint(NSLayoutConstraint(item: usernameName, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -100))
        
        //self.view.addConstraint(NSLayoutConstraint(item: emailAddressName, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        ///self.view.addConstraint(NSLayoutConstraint(item: emailAddressName, attribute: .centerY, relatedBy: .equal, toItem: usernameName, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        
        //self.view.addConstraint(NSLayoutConstraint(item: passwordName, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        //self.view.addConstraint(NSLayoutConstraint(item: passwordName, attribute: .centerY, relatedBy: .equal, toItem: emailAddressName, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        
        //self.view.addConstraint(NSLayoutConstraint(item: createAccount, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        //self.view.addConstraint(NSLayoutConstraint(item: createAccount, attribute: .centerY, relatedBy: .equal, toItem: passwordName, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        
        //self.view.addConstraint(NSLayoutConstraint(item: cancelCreating, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        //self.view.addConstraint(NSLayoutConstraint(item: cancelCreating, attribute: .centerY, relatedBy: .equal, toItem: createAccount, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        
        //view.backgroundColor = UIColor(red: 114/255, green: 54/255, blue: 128/255, alpha: 0.8)
        
        //usernameName.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: usernameName, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        //usernameName.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        //usernameName.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15.0).isActive = true
        //passwordName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        //passwordName.centerYAnchor.constraint(equalTo: usernameName.centerYAnchor, constant: -50).isActive = true
        
        //emailAddressName.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0)
        //emailAddressName.centerYAnchor.constraint(equalTo: usernameName.centerYAnchor, constant: -50).isActive = true
        
        //createAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //createAccount.centerYAnchor.constraint(equalTo: passwordName.centerYAnchor, constant: -45).isActive = true
        
        //cancelCreating.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //cancelCreating.centerYAnchor.constraint(equalTo: createAccount.centerYAnchor, constant: -15).isActive = true
        
        //usernameName.addConstraint(NSLayoutConstraint(item: usernameName, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0))
        
        //createAccount Button Properties
        //createAccount.center.x = view.center.x
        createAccount.frame.size = CGSize(width: 200, height: 38)
        createAccount.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        createAccount.layer.cornerRadius = 20
        view.addSubview(createAccount)
        //createAccount.clipsToBounds = true
        
        //cancelCreating properties properties
        //cancelCreating.center.x = view.center.x
        cancelCreating.frame.size = CGSize(width: 55, height: 30)
        cancelCreating.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        cancelCreating.layer.cornerRadius = 20
        view.addSubview(cancelCreating)
        //cancelCreating.clipsToBounds = true
        
        usernameName.frame.size.height = 42
        usernameName.frame.size.width = 254
        passwordName.frame.size.height = 42
        passwordName.frame.size.width = 254
        emailAddressName.frame.size.height = 42
        emailAddressName.frame.size.width = 254
        
        usernameName.center.x = view.center.x
        usernameName.center.y = view.center.y - view.bounds.height/6
        
        emailAddressName.center.x = view.center.x
        emailAddressName.center.y = usernameName.center.y + view.bounds.height/8
        
        passwordName.center.x = view.center.x
        passwordName.center.y = emailAddressName.center.y + view.bounds.height/8
        
        createAccount.center.x = view.center.x
        createAccount.center.y = passwordName.center.y + view.bounds.height/6
        
        cancelCreating.center.x = view.center.x
        cancelCreating.center.y = createAccount.center.y + view.bounds.height/12
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



