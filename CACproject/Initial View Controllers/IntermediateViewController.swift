//
//  IntermediateViewController.swift
//  CACproject
//
//  Created by Timothy Park on 10/23/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit

class intermediateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let categoryTitles: [String] = ["Biotechnology 👩🏼‍🔬",
                                    "Policy 👨🏻‍⚖️", "Humanities 🌍", "Startups 🤑", "Engineering 👩🏼‍🔧", "STEM 📚", "Social Media 🙉", "Education 👨🏻‍🎓", "Tech 👩🏿‍💻", "Web 👩🏻‍💻", "Applications 📲", "Sports 🏃🏻‍♀️"]
    
    // add food, and other stuff, and more colors
    
    let colorArray: [UIColor] = [UIColor(red:0.87, green:0.29, blue:0.29, alpha:1.0), UIColor(red:0.87, green:0.64, blue:0.29, alpha:1.0), UIColor(red:0.87, green:0.78, blue:0.29, alpha:1.0),
                                 
                                 UIColor(red:0.72, green:0.87, blue:0.29, alpha:1.0), UIColor(red:0.48, green:0.87, blue:0.29, alpha:1.0), UIColor(red:0.29, green:0.87, blue:0.56, alpha:1.0), UIColor(red:0.29, green:0.87, blue:0.84, alpha:1.0), UIColor(red:0.29, green:0.77, blue:0.87, alpha:1.0), UIColor(red:0.29, green:0.63, blue:0.87, alpha:1.0), UIColor(red:0.29, green:0.49, blue:0.87, alpha:1.0), UIColor(red:0.31, green:0.29, blue:0.87, alpha:1.0), UIColor(red:0.69, green:0.29, blue:0.87, alpha:1.0), UIColor(red:0.87, green:0.29, blue:0.67, alpha:1.0)]
    
    var popup: UIView!
    var messageText: UILabel!
//    @IBOutlet weak var doneButton: UIButton!
    
    //user defaults for storage
    //moved var userDefaultsCategoryShit: [String] = [] to app delegate
    let defaults = UserDefaults.standard
    //user defaults for storage
    
    let doneButton: UIButton = UIButton()
    @IBOutlet weak var followButton: UIView!
    @IBOutlet weak var categoryTitle: UITableViewCell!
    @IBOutlet weak var categoryTableView: UITableView!
    
    var userDefaultsCategoryShit: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDoneButton()
        doneButton.addTarget(self, action: #selector(moveToTabBar), for: .touchUpInside)
        
//        self.view.addSubview(messageText)
//        messageText.isHidden = true
        
        defaults.set(userDefaultsCategoryShit, forKey: "iLoveYou")
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        categoryTableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        categoryTableView.separatorColor = UIColor.white
        
        self.setTableView()
        //self.setNavBar()
        //self.setFloatingButton() 
        
        print("hi")
        
        //when view starts
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //you can dispose of stuff here
    }
    
    func setDoneButton() {
        
        self.view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setImage(#imageLiteral(resourceName: "ic_trending_flat_white_36pt"), for: .normal)
        doneButton.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.39, alpha:1.0)
        doneButton.frame.size = CGSize(width: 50, height: 50)
        doneButton.layer.cornerRadius = 25
//        doneButton.frame.size.width = 100
//        doneButton.frame.size.height = 30
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
//        view.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .centerX, relatedBy: .equal, toItem: categoryTableView, attribute: .centerX, multiplier: 1.0, constant: 40.0))
//        view.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .centerY, relatedBy: .equal, toItem: categoryTableView, attribute: .centerY, multiplier: 1.0, constant: 100.0))

    }
    
    @objc func moveToTabBar() {
        
        doneButton.pulsate()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moveToTabBar = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        moveToTabBar.modalTransitionStyle = .flipHorizontal
        moveToTabBar.view.layer.speed = 2.0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = moveToTabBar
        
//        let interMediate = intermediateViewController()
//        interMediate.modalTransitionStyle = .crossDissolve
//        interMediate.view.layer.speed = 0.2
//        print("ur ok")
//        self.present(interMediate, animated: true, completion: nil)
        
    }
    
    func setTableView() {
        
//        followButton.backgroundColor = UIColor.cyan
//        followButton.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
//        cell.categoryTitle = categoryTitles[indexPath.row]
//        cell.backgroundColor = colorArray[indexPath.row]
        
        cell.textLabel?.textAlignment = NSTextAlignment.justified
        cell.textLabel?.text = categoryTitles[indexPath.row]
        cell.backgroundColor? = colorArray[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        //cell.textLabel?.textColor = UIColor.white
        cell.tintColor = UIColor.white
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            cell.accessoryView?.frame.size = CGSize(width: 50, height: 50)
            userDefaultsCategoryShit.append(categoryTitles[indexPath.row])
            print("\(categoryTitles[indexPath.row]) has been added to your categories")
            
            //
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 12)
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self.categoryTableView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self.categoryTableView, attribute: .centerY, multiplier: 1.85, constant: 0.0))
//            label.center.x = view.center.x
//            label.center.y = view.center.y - 100
            label.text = "\(categoryTitles[indexPath.row]) has been added"
            label.fadeIn()
            label.fadeOut()
            
            
//            messageText.text = "\(categoryTitles[indexPath.row]) has been added"
//            messageText.isHidden = false
//            self.fadeViewInThenOut(view: messageText, delay: 0.1)
            
//            UIView.transition(with: messageText, duration: 3.0, options: .transitionCrossDissolve, animations: {
//                self.messageText.text = "\(self.categoryTitles[indexPath.row]) has been added to your categories"
//            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            if userDefaultsCategoryShit.contains(categoryTitles[indexPath.row]) {
                userDefaultsCategoryShit.remove(e: categoryTitles[indexPath.row])
                print("\(categoryTitles[indexPath.row]) has been removed to your categories")
                
                let label2: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
                view.addSubview(label2)
                label2.translatesAutoresizingMaskIntoConstraints = false
                label2.font = UIFont.boldSystemFont(ofSize: 12)
                view.addConstraint(NSLayoutConstraint(item: label2, attribute: .centerX, relatedBy: .equal, toItem: self.categoryTableView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                view.addConstraint(NSLayoutConstraint(item: label2, attribute: .centerY, relatedBy: .equal, toItem: self.categoryTableView, attribute: .centerY, multiplier: 1.85, constant: 0.0))
                //            label.center.x = view.center.x
                //            label.center.y = view.center.y - 100
                label2.text = "\(categoryTitles[indexPath.row]) has been removed"
                label2.fadeIn()
                label2.fadeOut()
                
                //
                
//                messageText.text = "\(categoryTitles[indexPath.row]) has been removed"
//                messageText.isHidden = false
//                self.fadeViewInThenOut(view: messageText, delay: 0.1)
            }
        }
    }

    func showAlert() {
        // customise your view
        
        popup = UIView(frame: CGRect(x: 100, y: 200, width: 200, height: 200))
        popup.backgroundColor = UIColor.clear
        popup.addSubview(messageText)
        
        popup.addConstraint(NSLayoutConstraint(item: messageText, attribute: .centerX, relatedBy: .equal, toItem: popup, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        popup.addConstraint(NSLayoutConstraint(item: messageText, attribute: .centerY, relatedBy: .equal, toItem: popup, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        // show on screen
        self.view.addSubview(popup)
        
        // set the timer
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc func dismissAlert(){
        if popup != nil { // Dismiss the view from here
            popup.removeFromSuperview()
        }
    }
    
    func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        let animationDuration = 0.25
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            // After the animation completes, fade out the view after a delay
            UIView.animate(withDuration: animationDuration, delay: delay, options: .transitionCrossDissolve, animations: { () -> Void in
                view.alpha = 0
            }, completion: nil)
        }
    }

//    func setNavBar() {
//
//            navigationBarz.topItem?.title = "Categories"
//            navigationBarz.frame.size = CGSize(width: self.view.frame.width, height: 100)
//
//
//        //self.transitioningDelegate
//        //self.translatesAutoresizingMaskIntoConstraints = false
//
//    }
    
    @IBAction func moveToNext() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moveToTabBar = storyboard.instantiateViewController(withIdentifier: "intermediateViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = moveToTabBar
    }
}

extension Array where Element: Equatable {
    
    mutating func remove(e: Element) {
        if let i = self.index(of: e) {
            self.remove(at: i)
        }
    }
}

extension UILabel {
    
    func fadeIn() {
        // Move our fade out code from earlier
        UILabel.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UILabel.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
}

class customCell1: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        
        //        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

