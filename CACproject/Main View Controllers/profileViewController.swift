//
//  profileViewController.swift
//  CACproject
//
//  Created by Timothy Park on 10/17/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit
import FirebaseDatabase

class profileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var backGround: UIView!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var bottomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2
        profilePic.backgroundColor = UIColor.lightGray
        profilePic.layer.borderWidth = 2
        profilePic.layer.borderColor = UIColor.white.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewController.imageTapped(gesture:)))
        
        profilePic.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        profilePic.isUserInteractionEnabled = true
        
        bottomTableView.register(MyCell.self, forCellReuseIdentifier: "cell")
        
        //navigationItem.title = "Brian Voong"
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        
        //profilePic.addGestureRecognizer(tapGesture)
        // make sure profilePic can be interacted with by user
        profilePic.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.20, green:0.40, blue:0.63, alpha:1.0)
        backGround.backgroundColor = UIColor(red:0.44, green:0.64, blue:0.82, alpha:1.0)
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        //self.navigationController?.navigationBar.titleTextAttributes = NS
        
        //UserDefaults.standard.set(bioLabel.text, forKey: "myBio")
        //bioLabel.text = ""
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            //Here you can initiate your new ViewController
            
//            let photoPickerViewController: photoPickerVC = photoPickerVC()
//            self.navigationController?.pushViewController(photoPickerViewController, animated: true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "photoPickerVC") as UIViewController
            self.present(vc, animated: true, completion: nil)
            
            
            
            
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
//            self.present(vc, animated: true, completion: nil)
            
//            let newViewController = photoPickerVC()
//            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    func setConstraints() {
        
//        view.addSubview(nameLabel)
//        view.addSubview(backGround)
//        view.addSubview(bottomTableView)
//        view.addSubview(profilePic)
//
//        backGround.translatesAutoresizingMaskIntoConstraints = false
//        profilePic.translatesAutoresizingMaskIntoConstraints = false
//        bottomTableView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.sendSubview(toBack: backGround)
//
//        view.addConstraint(NSLayoutConstraint(item: profilePic, attribute: .centerX, relatedBy: .equal, toItem: backGround, attribute: .centerX, multiplier: 1.0, constant: 0.0))
//        view.addConstraint(NSLayoutConstraint(item: profilePic, attribute: .centerY, relatedBy: .equal, toItem: backGround, attribute: .centerY, multiplier: 1.0, constant: 0.0))
//
//        backGround.bounds.size = CGSize(width: view.bounds.width, height: 300)
//        backGround.frame.size = CGSize(width: 375, height: 202)
//        backGround.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        backGround.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        backGround.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        backGround.bottomAnchor.constraint(equalTo: bottomTableView.topAnchor, constant: 0.0).isActive = true
//
//        backGround.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.3, alpha: 1.0)
//
//        nameLabel.center.x = view.center.x
//        nameLabel.center.y = profilePic.center.y + 20
//
//        bottomTableView.bounds.size = CGSize(width: 377, height: 344)
//        bottomTableView.center.x = view.center.x
//        bottomTableView.topAnchor.constraint(equalTo: backGround.bottomAnchor).isActive = true
//        bottomTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
//        bottomTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
//        bottomTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//
//        backGround.alpha = 0.8
//
//        profilePic.layer.borderWidth = 2
//        profilePic.layer.borderColor = UIColor.white.cgColor
//        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
//        profilePic.clipsToBounds = true
        
        //profilePic.center.x = backGround.center.x
        //profilePic.center.y = backGround.center.y
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return bottomTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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

class photoPickerVC: UIViewController {
    
    //let navBar: UINavigationBar = UINavigationBar()
    //let doneButton: UIBarButtonItem = UIBarButtonItem()
    let chooseFromAlbum: UIButton = UIButton()
    let takePhoto: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setLayout()
        //setNavigatorBar()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLayout() {
        
        //self.view.addSubview(navBar)
        self.view.addSubview(chooseFromAlbum)
        self.view.addSubview(takePhoto)
        
        //doneButton.translatesAutoresizingMaskIntoConstraints = false
        chooseFromAlbum.translatesAutoresizingMaskIntoConstraints = false
        takePhoto.translatesAutoresizingMaskIntoConstraints = false
        
        UIApplication.shared.statusBarStyle = .lightContent
        //let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
    }
    
    func setNavigatorBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Photos")
        
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction(sender:)))
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(doneAction))
//        navItem.rightBarButtonItem = doneItem
//        navBar.setItems([navItem], animated: false)
//        self.view.addSubview(navBar)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        navBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.height)
        navBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        navBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        
    }
    
    @objc func doneAction(sender: UIButton!) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
//    loginButton.center.x = view.center.x
//    loginButton.frame.size = CGSize(width: 171, height: 38)
//    loginButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
//    loginButton.layer.cornerRadius = 20
//    loginButton.clipsToBounds = true
    
    
}

class MyCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
}
