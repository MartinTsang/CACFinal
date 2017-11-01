//
//  ProfileVC.swift
//  Congressional
//
//  Created by user on 10/29/17.
//  Copyright © 2017 Martinia. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var categoryView: UICollectionView!
    var infoView = UIView()
    var name = UILabel()
    var categories = [String]()
    var profilePicture = UIView()
    var categoryTitle = UILabel()
    var postTitle = UILabel()
    var ref: DatabaseReference?
    var myPostList = [CardsData]()
    var profileTitle = UILabel()
    var myPosts = UITableView()
    var brushCenterX: CGFloat?
    var brushCenterY: CGFloat?
    var unbrushplace: CGFloat?
    var brush1 = UIView()
    var brush2 = UIView()
    var brush3 = UIView()
    var brush4 = UIView()
    var likesCountList = [Int]()
    var myPostsAdded = false
    var rainbow = CategoryTitles()
    var colorArray = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.removeFromSuperview()
        
        let defaults = UserDefaults.standard
        if let categoryList = defaults.object(forKey: "userCategoryList") as? [String]{
            self.categories = categoryList
        }
        unbrushplace = self.view.frame.height*3/2
        brushCenterX = view.center.x
        brushCenterY = view.center.y
        addBrushEffect(brush: brush1, x: 0, y: -view.bounds.height)
        addBrushEffect(brush: brush2, x: view.bounds.width/4 ,y: view.bounds.height*2)
        addBrushEffect(brush: brush3, x: view.bounds.width/2 ,y: -view.bounds.height)
        addBrushEffect(brush: brush4, x: view.bounds.width*3/4 ,y: view.bounds.height*2)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.Unbrush), name:NSNotification.Name(rawValue: "NotificationID"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.reference), name:NSNotification.Name(rawValue: "myNewPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.updateCategories), name:NSNotification.Name(rawValue: "userCategoryChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.reference), name:NSNotification.Name(rawValue: "liked"), object: nil)
        colorArray = rainbow.colorArray
        ref = Database.database().reference()
        
        reference()
        // Do any additional setup after loading the view.
        addInfo()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 180, height: view.frame.height/15 - 10)
        addMyPosts()
        addCategoryTitle()
        addPostTitle()
        addNavBar()
        categoryView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height/5 + view.frame.width/20 + view.frame.height*0.1, width: view.frame.width, height: view.frame.height/15), collectionViewLayout: layout)
        categoryView.backgroundColor = .white
        view.addSubview(categoryView)
        categoryView.register(selectedCategories.self, forCellWithReuseIdentifier: "categoryCell")
        categoryView.dataSource = self
        categoryView.delegate = self
    }
    
    func addNavBar(){
        let topBar = UIView(frame: CGRect(x: -2, y: -2, width: view.frame.width + 4, height: view.frame.height*0.1 + 2))
        topBar.backgroundColor = UIColor.white
        topBar.layer.borderWidth = 0.5
        topBar.layer.borderColor = (UIColor.black).cgColor
        view.addSubview(topBar)
        
        let navBarTitle = UILabel()
        navBarTitle.text = "Profile"
        topBar.addSubview(navBarTitle)
        navBarTitle.backgroundColor = .clear
        navBarTitle.textAlignment = .center
        navBarTitle.font = UIFont.systemFont(ofSize: topBar.frame.height/4, weight: UIFont.Weight.semibold)
        navBarTitle.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .left, relatedBy: .equal, toItem: topBar, attribute: .left, multiplier: 1, constant: view.frame.width/2-topBar.frame.height/2)
        let rightConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .right, relatedBy: .equal, toItem: topBar, attribute: .right, multiplier: 1, constant: -view.frame.width/2+topBar.frame.height/2)
        let topConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .top, relatedBy: .equal, toItem: topBar, attribute: .top, multiplier: 1, constant: topBar.frame.height/4+8)
        let bottomConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .bottom, relatedBy: .equal, toItem: topBar, attribute: .bottom, multiplier: 1, constant: -topBar.frame.height/4+10)
        topBar.addConstraints([leftConstraints,rightConstraints,topConstraints,bottomConstraints])
    }
    
    @objc func updateCategories(){
        let defaults = UserDefaults.standard
        if let categoryList = defaults.object(forKey: "userCategoryList") as? [String]{
            self.categories = categoryList
        }
        categoryView.reloadData()
    }
    
    @objc func reference(){
        ref?.child("PostsData").observe(.value, with: {(snapshot) in
            let defaults = UserDefaults.standard
            var PostColor: UIColor?
            
            let userPosts = defaults.object(forKey: "userPostList") as? [String]
            if userPosts != nil{
                self.likesCountList.removeAll()
                self.myPostList.removeAll()
                for userPostsNum in userPosts!{
                    for Postsdata in snapshot.children.allObjects as! [DataSnapshot]{
                        let postNum = Postsdata.key
                        print(postNum + userPostsNum)
                        if(postNum == userPostsNum){
                            let postObject = Postsdata.value as? [String: AnyObject]
                            let cardCategory = postObject?["Category"]
                            let cardTitle = postObject?["Title"]
                            let cardContent = postObject?["Content"]
                            let ColorData = Postsdata.childSnapshot(forPath: "Color")
                                    if(ColorData.childrenCount > 0 && ColorData.key == "Color"){
                                        let color = ColorData.value as? [String: CGFloat]
                                        print(ColorData.key)
                                        let red = color?["red"]
                                        let green = color?["green"]
                                        let blue = color?["blue"]
                                        let alpha = color?["alpha"]
                                        PostColor = UIColor(red: (red)!, green: (green)!, blue: (blue)!, alpha: (alpha)!)
                                    }
                                let post = CardsData(category: cardCategory as? String, title: cardTitle as? String, content: cardContent as? String, postNum: postNum, color: PostColor)
                                self.myPostList.append(post)
                                print(self.myPostList)
                            
                            
                            
                            self.ref?.child("Likes").observe(.value, with: {(snapshot) in
                                for Postsdata in snapshot.children.allObjects as! [DataSnapshot]{
                                    for postsNumber in Postsdata.children.allObjects as! [DataSnapshot]{
                                        let postNum = postsNumber.key
                                        if(postNum == userPostsNum){
                                            //print("yes")
                                            let likes = postsNumber.value as? Int
                                            self.likesCountList.append(likes!)
                                        }
                                    }
                                }
                                self.myPosts.reloadData()
                            })
                            
                        }
                    }
                }
            }
        })
    }
    
    func addProfileTitle(){
        profileTitle.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width/7)
        profileTitle.backgroundColor = .lightGray
        profileTitle.text = "Profile"
        profileTitle.textAlignment = .center
        view.addSubview(profileTitle)
    }
    
    func addCategoryTitle(){
        categoryTitle.frame = CGRect(x: 0, y: view.frame.height/5 + view.frame.height*0.1, width: view.frame.width, height: view.frame.width/20)
        categoryTitle.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        categoryTitle.text = "  Your Categories"
        categoryTitle.font = UIFont.systemFont(ofSize: view.frame.width/30, weight: UIFont.Weight.bold)
        view.addSubview(categoryTitle)
    }
    
    func addPostTitle(){
        postTitle.frame = CGRect(x: 0, y: view.frame.height/5 + view.frame.width/20 + view.frame.height/15 + view.frame.height*0.1, width: view.frame.width, height: view.frame.width/20)
        postTitle.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        postTitle.text = "  Your Posts"
        postTitle.font = UIFont.systemFont(ofSize: view.frame.width/30, weight: UIFont.Weight.bold)
        view.addSubview(postTitle)
    }
    
    
    func addInfo(){
        infoView = UILabel(frame: CGRect(x: 0, y: view.frame.height*0.1, width:  view.frame.width, height:  view.frame.height/5))
        //infoView.backgroundColor = UIColor.lightGray
        view.addSubview(infoView)
        addName()
        addPicture()
    }
    
    func addName(){
        name = UILabel(frame: CGRect(x: infoView.frame.height*5/6, y: 0, width:  view.frame.width - infoView.frame.height, height:  view.frame.height/5))
        name.text = "Martin Zeng"
        name.textAlignment = .center
        name.font = UIFont.systemFont(ofSize: view.frame.height*0.75/14, weight: UIFont.Weight.semibold)
        //name.backgroundColor = .brown
        infoView.addSubview(name)
    }
    
    func addPicture(){
        profilePicture = UIView(frame: CGRect(x: infoView.frame.height/6, y: infoView.frame.height/6, width: infoView.frame.height*2/3, height: infoView.frame.height*2/3))
        //profilePicture.backgroundColor = .blue
        profilePicture.backgroundColor = UIColor(patternImage: UIImage(named: "hi")!)
        profilePicture.layer.borderWidth = 3
        profilePicture.layer.borderColor = UIColor.lightGray.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        infoView.addSubview(profilePicture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
///////Category collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count//categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! selectedCategories
        cell.category.text = categories[indexPath.item]
        cell.category.backgroundColor = colorArray[indexPath.row]
        //cell.layer.cornerRadius = 30
        //cell.contentView.frame = c
        //cell.contentView.h = 50
        return cell
    }
    
}


class selectedCategories: UICollectionViewCell{
    
    var category = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Custom Cell sdfdsf "
        return label
    }()
    
    func setupView(){
        category = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        category.translatesAutoresizingMaskIntoConstraints = false
        category.text = "this and that"
        category.textAlignment = .center
        category.textColor = .white
        //category.sizeToFit()
        //category.set
        addSubview(category)
        category.backgroundColor = .red
        category.clipsToBounds = true;
        category.layer.cornerRadius = 10
        //nameLabel.font = UIFont.systemFont(ofSize: (superview?.frame.width)!/14, weight: UIFont.Weight.regular)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ProfileVC: UITableViewDelegate, UITableViewDataSource{
    
    func expandInfo(color: UIColor, title: String, category: String, content: String) {
        let duration = 0.35
        animate(duration: Float(duration), color: color)
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration*4), execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ExpandInfoVC") as! ExpandInfoVC
            vc.bgColor = color
            vc.titleText = title
            vc.categoryText = category
            vc.contentText = content
            
            self.present(vc, animated: false, completion: nil)
            //self.brush4.removeFromSuperview()
        })
        
    }
    
    func animate(duration: Float, color: UIColor){
        brush1.alpha = 1
        brush2.alpha = 1
        brush3.alpha = 1
        brush4.alpha = 1
        dipColor(brush: brush1, color: color)
        dipColor(brush: brush2, color: color)
        dipColor(brush: brush3, color: color)
        dipColor(brush: brush4, color: color)
        
        print(duration)
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.brush1.center = CGPoint(x: self.view.frame.width/8,y: self.brushCenterY!)
            //self.tabBarController?.tabBar.
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration) - 0.2, execute: {
            UIView.animate(withDuration: TimeInterval(duration)+0.1, animations: {
                self.brush2.center = CGPoint(x: self.view.frame.width/4+self.view.frame.width/8,y: self.brushCenterY!)
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration*2) - 0.14, execute: {
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                self.brush3.center = CGPoint(x: self.view.frame.width/2 + self.view.frame.width/8,y: self.brushCenterY!)
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration*3) - 0.27, execute: {
            UIView.animate(withDuration: TimeInterval(duration+0.1), animations: {
                self.brush4.center = CGPoint(x: self.view.frame.width*3/4 + self.view.frame.width/8 ,y: self.brushCenterY!)
            })
        })
        
    }
    
    func dipColor(brush: UIView, color: UIColor){
        brush.backgroundColor = color
        //brush.bringSubview(toFront: (self.tabBarController?.tabBar)!)
    }
    
    func addBrushEffect(brush: UIView,x: CGFloat, y: CGFloat){
        brush.frame = CGRect(x: CGFloat(x), y: y, width: view.frame.width/4, height: view.frame.height)
        brush.alpha = 1
        self.tabBarController?.view.addSubview(brush)
    }

    func addMyPosts(){
        
        
        myPosts = UITableView(frame: CGRect(x: 0, y: view.frame.height/5 + view.frame.width/20 + view.frame.height/15 + view.frame.height*0.1 + view.frame.width/20, width: view.frame.width, height: view.frame.height/2))
        view.addSubview(myPosts)
        myPosts.register(myPostsCell.self, forCellReuseIdentifier: "cell")
        myPosts.delegate = self
        myPosts.dataSource = self
        myPosts.separatorStyle = .none
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myPostList.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myPostsCell
        cell.view.frame = CGRect(x: view.frame.width*0.05, y: (cell.contentView.frame.height-view.frame.height/9)/2, width: view.frame.width*0.9, height: view.frame.height/9)
        cell.view.layer.cornerRadius = cell.view.frame.height/8
        cell.addLikesTab()
        cell.selectionStyle = .default
        if(myPostList.count > 0){
        cell.view.text = "  " + myPostList[indexPath.row].title!
        }
        if(likesCountList.count > 0){
            cell.likes.text = "Likes: \(likesCountList[indexPath.row])"
        }
        let color = myPostList[indexPath.row].color
        cell.tintColor = color
        cell.view.backgroundColor = color
        cell.view.textColor = .white
        let colorView = UIView()
        colorView.backgroundColor = color
        cell.selectedBackgroundView = colorView
        //cell.selectionStyle = .none
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let color = myPostList[indexPath.row].color
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath) as? myPostsCell
        let color = currentCell?.tintColor
        //print(currentCell?.tintColor)
        let title = myPostList[indexPath.row].title
        let category = myPostList[indexPath.row].category
        let content = myPostList[indexPath.row].content
        expandInfo(color: color!, title: title!, category: category!, content: content!)
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/9 + 15
    }
}

class myPostsCell: UITableViewCell {
    
    //@IBOutlet weak var view: UIView!
    var view = UILabel()
    var likes = UILabel()
    var likesTab = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        view.layer.cornerRadius = 10
        contentView.addSubview(view)
        view.clipsToBounds = true;
        view.textAlignment = NSTextAlignment.left
    }
    
    func addLikesTab(){
        likesTab = UIView(frame: CGRect(x: view.frame.width - view.frame.width/4 - 5, y: view.frame.height - view.frame.height/4 - 5, width: view.frame.width/4, height: view.frame.height/4))
        likesTab.backgroundColor = .white
        likesTab.layer.cornerRadius =  contentView.frame.height/30
        view.addSubview(likesTab)
        likesTab.layer.cornerRadius = likesTab.frame.height/2
        addLikes()
    }
    
    func addLikes(){
        likes.frame = CGRect(x: 5, y: 0, width: likesTab.frame.width - 10, height: likesTab.frame.height)
        likes.text = "Likes: 251"
        likes.numberOfLines = 1
        likes.adjustsFontSizeToFitWidth = true
        likes.textAlignment = .center
        likes.textColor = .red
        likes.backgroundColor = .clear
        likesTab.addSubview(likes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }
    
    /*
     override func setSelected(_ selected: Bool, animated: Bool) {
     super.setSelected(selected, animated: false)
     
     // Configure the view for the selected state
     }*/
}

extension ProfileVC{
    @objc public func Unbrush() {
        //self.brush4.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                self.brush4.center = CGPoint(x: self.view.frame.width*3/4 + self.view.frame.width/8 ,y: self.unbrushplace!)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.brush3.center = CGPoint(x: self.view.frame.width/2 + self.view.frame.width/8,y: CGFloat(-Float(self.unbrushplace!)/3))
                })
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.brush2.center = CGPoint(x: self.view.frame.width/4+self.view.frame.width/8,y: self.unbrushplace!)
                })
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.brush1.center = CGPoint(x: self.view.frame.width/8,y: CGFloat(-Float(self.unbrushplace!)/3))
                })
            })
        })
    }
}
