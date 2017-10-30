//
//  searchViewController.swift
//  CACproject
//
//  Created by Timothy Park on 10/18/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit

class searchViewController: UIViewController {

    let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    
    var myArray = ["AAA", "BBB", "CCC", "DDD"]
    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        navigationItem.title = "Categories"
        categoryTableView.dataSource = self
        //categoryTableView.separatorStyle = .none
        categoryTableView.register(roundTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(categoryTableView)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTableView() {
        
    }
    
    func addNewCategory() {
        
    }
    
    func followCategory() {
        
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


extension searchViewController: UITableViewDelegate, UITableViewDataSource {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = "it works"
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        
//        cell.myLabel1.text = myArray[indexPath.row]
//        cell.myLabel2.text = "\(indexPath.row)"
//        cell.myButton1.addTarget(self, action: #selector(pressedBrowser(sender: )), for: UIControlEvents.touchUpInside)
//        cell.myButton2.addTarget(self, action: #selector(pressedTelephone(sender: )), for: UIControlEvents.touchUpInside)
        
        
        //adding text to cells
        let textView: UITextView = UITextView()
        textView.textColor = UIColor.black
        textView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(textView)
        
        return cell
        
//
//        let leadingConstraint = NSLayoutConstraint(item: cell.contentView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: textView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 8.0)
//
//        let trailingConstraint = NSLayoutConstraint(item: cell.contentView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: textView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: -8.0)
//
//        cell.contentView.addConstraint(leadingConstraint)
//        cell.contentView.addConstraint(trailingConstraint)
//
//        let topConstraint = NSLayoutConstraint(item: cell.contentView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: textView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
//
//        let bottomConstraint = NSLayoutConstraint(item: cell.contentView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: textView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
//
//        cell.contentView.addConstraint(topConstraint)
//        cell.contentView.addConstraint(bottomConstraint)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func addContentView() {
        
    }
    
    
    
}

