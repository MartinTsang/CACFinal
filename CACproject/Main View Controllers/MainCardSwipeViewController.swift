//
//  MainCardSwipeViewController.swift
//  CACproject
//
//  Created by Timothy Park on 10/17/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainCardSwipeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        //loadingView.removeFromSuperview()
        
//        let bounds = self.navigationController!.navigationBar.bounds
//        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
//        let navItem = UINavigationItem(title: "Feed")
//        let doneItem = (UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: nil /*nil for now*/))
//        navItem.rightBarButtonItem = doneItem;
//        self.view.addSubview(navBar)
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLoadingConstraints() {
        //loadingView.
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

extension UIViewController {
    func createNavigationBars() {
        let bounds = self.navigationController!.navigationBar.bounds
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        let navItem = UINavigationItem(title: "Feed")
        let doneItem = (UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: nil /*nil for now*/))
        navItem.rightBarButtonItem = doneItem;
        self.view.addSubview(navBar)
        
        
    }
}
