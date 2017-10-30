//
//  SplashViewController.swift
//  CACproject
//
//  Created by Timothy Park on 10/20/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit
import RevealingSplashView

class SplashViewController: UIViewController {
    
    let splashyBoi: RevealingSplashView = RevealingSplashView(iconImage: UIImage(named: "UGLYLOGOFINALFORSPLASh")! , iconInitialSize: CGSize(width: 200, height: 200), backgroundColor: UIColor(red:0.44, green:0.82, blue:0.56, alpha:1.0))

    override func viewDidLoad() {
        
        self.view.addSubview(splashyBoi)
        
        splashyBoi.duration = 2.3
        
        splashyBoi.iconColor = UIColor.red
        splashyBoi.useCustomIconColor = false
        
        splashyBoi.animationType = SplashAnimationType.twitter
        
        splashyBoi.startAnimation(){
            self.setNeedsStatusBarAppearanceUpdate()
            
            let moveToLogin = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = moveToLogin
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
//            self.present(vc, animated: true, completion: nil)
            print("Completed")
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return !UIApplication.shared.isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
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

