//
//  ViewController.swift
//  Congressional
//
//  Created by user on 10/10/17.
//  Copyright © 2017 Martinia. All rights reserved.
//

import UIKit
import Firebase

class CardsViewController: UIViewController{
    
    
    // @IBOutlet weak var cardView: CardView!
    //@IBOutlet weak var thumbImageView: UIImageView!
    
    //@IBOutlet weak var TabBar: RAMAnimatedTabBarItem!
    /*if let nav = segue.destination as? UINavigationController, let classBVC = nav.topViewController as? CardViewDelegate {
     classBVC.delegate = self
     }*/
    var ref: DatabaseReference?
    
    var brushCenterX: CGFloat?
    var brushCenterY: CGFloat?
    var unbrushplace: CGFloat?
    var brush1 = UIView()
    var brush2 = UIView()
    var brush3 = UIView()
    var brush4 = UIView()
    var expandView = ExpandInfoVC()
    var button = UIButton()
    var dislikeButton = UIButton()
    var likeButton = UIButton()
    var topBar = UIView()
    var addPostButton = UIButton()
    var testButton = UIButton()
    
    var currentCardNumber = 0
    var cardStackView = UIView()
    var postsList = [CardsData]()
    var likeButtonPressable = true
    var dislikeButtonPressable = true
    
    struct Card{
        var cardView: SwipableCardView?
        var postNum: String?
        //var User = user
    }
    
    var backCard: Card? = nil
    var frontCard: Card? = nil
    //var User: [User]?
    
    override func viewDidLoad() {
        //let pangesture = UIPanGestureRecognizer(target: cardView, action: #selector(self.swipingCard))
        super.viewDidLoad()
        ref = Database.database().reference()
        unbrushplace = self.view.frame.height*3/2
        brushCenterX = view.center.x
        brushCenterY = view.center.y
        addBrushEffect(brush: brush1, x: 0, y: -view.bounds.height)
        addBrushEffect(brush: brush2, x: view.bounds.width/4 ,y: view.bounds.height*2)
        addBrushEffect(brush: brush3, x: view.bounds.width/2 ,y: -view.bounds.height)
        addBrushEffect(brush: brush4, x: view.bounds.width*3/4 ,y: view.bounds.height*2)
        
        ref?.child("PostsData").queryOrderedByKey().observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                //self.currentCardNumber = 0
                self.postsList.removeAll()
                var PostColor: UIColor?
                for Postsdata in snapshot.children.allObjects as! [DataSnapshot]{
                    let postNum = Postsdata.key
                    if(Int(postNum)! > 0){
                    let postObject = Postsdata.value as? [String: AnyObject]
                    let cardCategory = postObject?["Category"]
                    let cardTitle = postObject?["Title"]
                    let cardContent = postObject?["Content"]
                    self.ref?.child("PostsData").child(postNum).observeSingleEvent(of: .value, with: {(Colorsnapshot) in
                        for ColorData in Colorsnapshot.children.allObjects as! [DataSnapshot]{
                            if(Colorsnapshot.childrenCount > 0 && ColorData.key == "Color"){
                                let color = ColorData.value as? [String: CGFloat]
                                print(ColorData.key)
                                let red = color?["red"]
                                let green = color?["green"]
                                let blue = color?["blue"]
                                let alpha = color?["alpha"]
                                PostColor = UIColor(red: (red)!, green: (green)!, blue: (blue)!, alpha: (alpha)!)
                            }
                        }
                        let post = CardsData(category: cardCategory as? String, title: cardTitle as? String, content: cardContent as? String, postNum: postNum, color: PostColor)
                        self.postsList.append(post)
                        
                        //self.postsList.reverse()
                        if self.frontCard == nil {
                            if let card = self.createCard(){
                                self.frontCard = card
                                self.view.addSubview((self.frontCard!.cardView)!)
                            }else{
                                self.frontCard = nil
                            }
                        }
                        if self.backCard == nil {
                            if let card = self.createCard(){
                                self.backCard = card
                                self.view.insertSubview(self.backCard!.cardView!, belowSubview: self.frontCard!.cardView!)
                            }else{
                                self.backCard = nil
                            }
                        }
                    })
                        
                    }
                }
               
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(CardsViewController.Unbrush), name:NSNotification.Name(rawValue: "NotificationID"), object: nil)
       addNavBar()
        
        addingButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func createCard() -> Card?{
        if postsList.count > 0 && currentCardNumber < postsList.count{
            let cardView = SwipableCardView(frame: CardFrame())
            cardView.delegate = self
            cardView.selection = true
            print("hi" + "\(postsList[currentCardNumber].color)")
            cardView.card.backgroundColor =  postsList[currentCardNumber].color
            cardView.layer.cornerRadius = cardView.frame.width*0.05
            cardView.cardTexts.text = postsList[currentCardNumber].content
            cardView.cardCategory.text = postsList[currentCardNumber].category
            cardView.cardTitle.text = postsList[currentCardNumber].title
            let postNum = postsList[currentCardNumber].postNum
            currentCardNumber += 1
            return Card(cardView: cardView, postNum: postNum)
        }else {
            return nil
        }
    }
    
    
    
    private func CardFrame() -> CGRect {
        return CGRect(x: view.frame.width*0.05, y: view.frame.height*0.15, width: view.frame.width * 0.9, height: view.frame.height*0.6)
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    ///////////////Buttons
    
    func addingButtons(){
        addingLikeButton() 
        addingDislikeButton()
        addingaddPostButton()
        //addingResetButton()
    }
    
    func addingTestButton(){
        testButton.setTitle("->", for: .normal)
        testButton.setTitleColor(UIColor.white, for: .normal)
        testButton.backgroundColor=UIColor.clear
        testButton.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        view.addSubview(testButton)
        testButton.titleLabel?.font = UIFont.systemFont(ofSize: topBar.frame.height/2, weight: UIFont.Weight.regular)
        testButton.addTarget(self, action:  #selector(test(_:)), for: .touchUpInside)
    }
    
    @objc func test(_ sender: UIButton){
        print("clicked")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LikedVC") as! LikedVC
        self.present(vc, animated: true, completion: nil)
    }
    
    func addNavBar(){
        
        topBar = UIView(frame: CGRect(x: -2, y: -2, width: view.frame.width + 4, height: view.frame.height*0.1 + 2))
        topBar.backgroundColor = UIColor.white
        topBar.layer.borderWidth = 0.5
        topBar.layer.borderColor = (UIColor.black).cgColor
        view.addSubview(topBar)
        
        let navBarTitle = UILabel()
        navBarTitle.text = "Feed"
        topBar.addSubview(navBarTitle)
        navBarTitle.backgroundColor = .clear
        navBarTitle.textAlignment = .center
        navBarTitle.font = UIFont.systemFont(ofSize: topBar.frame.height/4, weight: UIFont.Weight.semibold)
        navBarTitle.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .left, relatedBy: .equal, toItem: topBar, attribute: .left, multiplier: 1, constant: view.frame.width/2-topBar.frame.height/3)
        let rightConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .right, relatedBy: .equal, toItem: topBar, attribute: .right, multiplier: 1, constant: -view.frame.width/2+topBar.frame.height/3)
        let topConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .top, relatedBy: .equal, toItem: topBar, attribute: .top, multiplier: 1, constant: topBar.frame.height/4+8)
        let bottomConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .bottom, relatedBy: .equal, toItem: topBar, attribute: .bottom, multiplier: 1, constant: -topBar.frame.height/4+10)
        topBar.addConstraints([leftConstraints,rightConstraints,topConstraints,bottomConstraints])
    }
    
    func addingaddPostButton(){
        addPostButton.setTitle("+", for: .normal)
        addPostButton.setTitleColor(UIColor.black, for: .normal)
        addPostButton.backgroundColor=UIColor.clear
        topBar.addSubview(addPostButton)
        addPostButton.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraints = NSLayoutConstraint(item: addPostButton, attribute: .left, relatedBy: .equal, toItem: topBar, attribute: .left, multiplier: 1, constant: view.frame.width-10-topBar.frame.height/2)
        let rightConstraints = NSLayoutConstraint(item: addPostButton, attribute: .right, relatedBy: .equal, toItem: topBar, attribute: .right, multiplier: 1, constant: -10)
        let topConstraints = NSLayoutConstraint(item: addPostButton, attribute: .top, relatedBy: .equal, toItem: topBar, attribute: .top, multiplier: 1, constant: topBar.frame.height/4+8)
        let bottomConstraints = NSLayoutConstraint(item: addPostButton, attribute: .bottom, relatedBy: .equal, toItem: topBar, attribute: .bottom, multiplier: 1, constant: -topBar.frame.height/4+5)
        topBar.addConstraints([leftConstraints,rightConstraints,topConstraints,bottomConstraints])
        addPostButton.titleLabel?.font = UIFont.systemFont(ofSize: topBar.frame.height/2, weight: UIFont.Weight.thin)
        addPostButton.addTarget(self, action: #selector(CardsViewController.addPost(_:)), for: .touchUpInside)
    }
    
    @objc func addPost(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddingPostPopUpVC") as! AddingPostPopUpVC
        self.present(vc, animated: true, completion: nil)
    }
    
    func addingLikeButton(){
        
        likeButton.backgroundColor = UIColor.green
        likeButton.frame = CGRect(x: view.frame.width*3/4 - view.frame.width/16, y: view.frame.height*0.8, width: view.frame.width/8, height: view.frame.width/8)
        likeButton.layer.cornerRadius = view.frame.width/16
        likeButton.addTarget(self, action: #selector(CardsViewController.LikeButton), for: .touchUpInside)
        view.addSubview(likeButton)
        likeButton.setTitle("✓", for: .normal)
        likeButton.contentHorizontalAlignment = .center
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: (view.frame.width/8)/1.5, weight: UIFont.Weight.heavy)
        likeButton.tintColor = .white
        likeButton.setTitleColor(UIColor.white,for: .normal)
    }
    
    func addingDislikeButton(){
        
        dislikeButton.backgroundColor = UIColor.red
        dislikeButton.frame = CGRect(x: view.frame.width*1/4 - view.frame.width/16, y: view.frame.height*0.8, width: view.frame.width/8, height: view.frame.width/8)
        dislikeButton.layer.cornerRadius = view.frame.width/16
        dislikeButton.addTarget(self, action: #selector(CardsViewController.DisLikeButton), for: .touchUpInside)
        view.addSubview(dislikeButton)
        dislikeButton.setTitle("✘", for: .normal)
        dislikeButton.contentHorizontalAlignment = .center
        dislikeButton.contentVerticalAlignment = .center
        dislikeButton.titleLabel?.font = UIFont.systemFont(ofSize: (view.frame.width/8)/1.9, weight: UIFont.Weight.thin)
        dislikeButton.tintColor = .white
        dislikeButton.setTitleColor(UIColor.white,for: .normal)
    }
    /*
     func addingResetButton(){
     button.setTitle("Reset", for: .normal)
     button.setTitleColor(UIColor.yellow,for: .normal)
     button.backgroundColor = UIColor.lightGray
     button.frame = CGRect(x: view.frame.width/2 - view.frame.width/16, y: view.frame.height*0.9, width: view.frame.width/8, height: view.frame.width/8)
     button.layer.cornerRadius = button.frame.width/2
     button.addTarget(self, action: #selector(ViewController.resetButton), for: .touchUpInside)
     view.addSubview(button)
     }
     
     @objc func resetButton(_sender: UIButton!){
     resetCard()
     }
     */
    @objc func LikeButton(_ sender: UIButton!){
        if(frontCard != nil && likeButtonPressable){
        sender.pulsate()
        //Unbrush()
        frontCard!.cardView?.like(isButton: true)
            likeButtonPressable = false
        }
    }
    
    @objc func DisLikeButton(_ sender: UIButton!){
        if(frontCard != nil){
        sender.pulsate()
        frontCard!.cardView?.disLike(isButton: true)
        }
    }
    
    func switchCards(){
        //print(backCard?.postNum)
        frontCard = backCard
        if let card = self.createCard(){
            self.backCard = card
            self.view.insertSubview(self.backCard!.cardView!, belowSubview: self.frontCard!.cardView!)
        }else{
            self.backCard = nil
        }
        likeButtonPressable = true
    }
}

extension CardsViewController: SwipableCardViewDelegate {
    func expandInfo() {
        let duration = 0.35
        
        animate(duration: Float(duration))
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration*4), execute: {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ExpandInfoVC") as! ExpandInfoVC
            vc.bgColor = self.frontCard?.cardView?.card.backgroundColor
            vc.titleText = self.frontCard?.cardView?.cardTitle.text
            vc.categoryText = self.frontCard?.cardView?.cardCategory.text
            vc.contentText = self.frontCard?.cardView?.cardTexts.text
            
        self.present(vc, animated: false, completion: nil)
            //self.brush4.removeFromSuperview()
        })
        
    }
    
    func animate(duration: Float){
            brush1.alpha = 1
            brush2.alpha = 1
            brush3.alpha = 1
            brush4.alpha = 1
        dipColor(brush: brush1)
        dipColor(brush: brush2)
        dipColor(brush: brush3)
        dipColor(brush: brush4)
        
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
    
    func dipColor(brush: UIView){
        brush.backgroundColor = frontCard?.cardView?.card.backgroundColor
        //brush.bringSubview(toFront: (self.tabBarController?.tabBar)!)
    }
    
    func addBrushEffect(brush: UIView,x: CGFloat, y: CGFloat){
        brush.frame = CGRect(x: CGFloat(x), y: y, width: view.frame.width/4, height: view.frame.height)
        brush.alpha = 1
        self.tabBarController?.view.addSubview(brush)
    }
    
    func swipedLeft() {
        //print("left")
        if(frontCard != nil){
        if let frontCard = frontCard {
            //self.frontCard?.cardView.removeFromSuperview()
            //saveSkip(frontCard.user)
            print("Card " + frontCard.postNum! + " got siwped left")
        }
        
        switchCards()
    }
    }
    
    func swipedRight() {
        
        //print("right")
        if(frontCard != nil){
        if let frontCard = frontCard {
            //self.frontCard?.cardView.removeFromSuperview()
            //saveLike(frontCard.user)
            //print("Card " + frontCard.postNum! + " got siwped right")
            let defaults = UserDefaults.standard
            if let userLikedList = defaults.object(forKey: "userLikedList") as? [String] {
                var newUserLikedList = userLikedList
                newUserLikedList.append(frontCard.postNum!)
                defaults.set(newUserLikedList, forKey: "userLikedList")
            }else{
                let userPostList = [frontCard.postNum]
                defaults.set(userPostList, forKey: "userLikedList")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
            ref?.child("Likes").child((frontCard.cardView?.cardCategory.text)!).observeSingleEvent(of: .value, with: {(snapshot) in
                //print(frontCard.postNum!)
                for PostsData in snapshot.children.allObjects as! [DataSnapshot]{
                    let post = PostsData.key
                    if(post == self.frontCard?.postNum!){
                        let likesCount = PostsData.value as? Int
                        //print(likesCount)
                        self.ref?.child("Likes").child((frontCard.cardView?.cardCategory.text)!).child(frontCard.postNum!).setValue(likesCount! + 1)
                    }}
                self.switchCards()
            })
        }
    }
    }
    
}

extension CardsViewController{
    
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
