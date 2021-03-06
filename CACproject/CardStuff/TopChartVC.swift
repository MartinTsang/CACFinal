//
//  TopChartVC.swift
//  Congressional
//
//  Created by user on 10/18/17.
//  Copyright © 2017 Martinia. All rights reserved.
//

import UIKit
import Firebase

class TopChartVC: UIViewController {
    
    var category = "Artificial Intelligence"
    
    var topPosts = [CardsData]()
    var topPostsNum: [String]?
    
    var currentCardNumber:Int = -1
    
    struct Card {
        var cardView: SwipableCardView?
    
    }
    
    var undid: Bool = false
    var backCard: Card?
    var frontCard: Card?
    
    var rankTab: UIView!
    var rank: UILabel!
    var cardView: SwipableCardView!
    var likes: UILabel!
    var likesTab: UIView!
    var UndoButton = UIButton()
    var cardNumberIndicator = UILabel()
    var indicatorNumber = 1
    var likesCountList = [Int]()
    var brushCenterX: CGFloat?
    var brushCenterY: CGFloat?
    var unbrushplace: CGFloat?
    var brush1 = UIView()
    var brush2 = UIView()
    var brush3 = UIView()
    var brush4 = UIView()
    
    var firstFetch = true
    var ref: DatabaseReference?
    var indicatorAdded = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(TopChartVC.Unbrush), name:NSNotification.Name(rawValue: "NotificationID"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(TopChartVC.reference), name:NSNotification.Name(rawValue: "liked"), object: nil)
        addingUndoButton()
        
        addNavBar()
        unbrushplace = self.view.frame.height*3/2
        brushCenterX = view.center.x
        brushCenterY = view.center.y
        addBrushEffect(brush: brush1, x: 0, y: -view.bounds.height)
        addBrushEffect(brush: brush2, x: view.bounds.width/4 ,y: view.bounds.height*2)
        addBrushEffect(brush: brush3, x: view.bounds.width/2 ,y: -view.bounds.height)
        addBrushEffect(brush: brush4, x: view.bounds.width*3/4 ,y: view.bounds.height*2)
        
        ref = Database.database().reference()
        reference()
        // Do any additional setup after loading the view.
    }
    
    func addNavBar(){
        let topBar = UIView(frame: CGRect(x: -2, y: -2, width: view.frame.width + 4, height: view.frame.height*0.1 + 2))
        topBar.backgroundColor = UIColor.white
        topBar.layer.borderWidth = 0.5
        topBar.layer.borderColor = (UIColor.black).cgColor
        view.addSubview(topBar)
        
        let navBarTitle = UILabel()
        navBarTitle.text = category
        topBar.addSubview(navBarTitle)
        navBarTitle.backgroundColor = .clear
        navBarTitle.textAlignment = .center
        navBarTitle.font = UIFont.systemFont(ofSize: topBar.frame.height/4, weight: UIFont.Weight.semibold)
        navBarTitle.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .left, relatedBy: .equal, toItem: topBar, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .right, relatedBy: .equal, toItem: topBar, attribute: .right, multiplier: 1, constant: 0)
        let topConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .top, relatedBy: .equal, toItem: topBar, attribute: .top, multiplier: 1, constant: topBar.frame.height/4+8)
        let bottomConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .bottom, relatedBy: .equal, toItem: topBar, attribute: .bottom, multiplier: 1, constant: -topBar.frame.height/4+10)
        topBar.addConstraints([leftConstraints,rightConstraints,topConstraints,bottomConstraints])
        
        let dismissButton = UIButton()
        dismissButton.setTitle("back", for: .normal)
        dismissButton.setTitleColor(UIColor.black, for: .normal)
        dismissButton.backgroundColor=UIColor.clear
        topBar.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        let buttonLeft = NSLayoutConstraint(item: dismissButton, attribute: .left, relatedBy: .equal, toItem: topBar, attribute: .left, multiplier: 1, constant: 10)
        let buttonRight = NSLayoutConstraint(item: dismissButton, attribute: .right, relatedBy: .equal, toItem: topBar, attribute: .right, multiplier: 1, constant: -view.frame.width-10 + topBar.frame.height)
        let buttonTop = NSLayoutConstraint(item: dismissButton, attribute: .top, relatedBy: .equal, toItem: topBar, attribute: .top, multiplier: 1, constant: topBar.frame.height/4+8)
        let buttonBot = NSLayoutConstraint(item: dismissButton, attribute: .bottom, relatedBy: .equal, toItem: topBar, attribute: .bottom, multiplier: 1, constant: -topBar.frame.height/4+5)
        topBar.addConstraints([buttonBot,buttonTop,buttonLeft,buttonRight])
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: topBar.frame.height/4, weight: UIFont.Weight.thin)
        dismissButton.addTarget(self, action: #selector(TopChartVC.dismissTopChart(_:)), for: .touchUpInside)
    }
    
    @objc func dismissTopChart(_ sender: UIButton){
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
    
    func initiateCards(){
        if(self.frontCard == nil){
            if let card = self.createCard(Undo: false){
                self.frontCard = card
                self.view.addSubview(self.frontCard!.cardView!)
            }
            
            
        }
        
        if(self.backCard == nil){
            print("thy es nil \(self.topPosts.count)")
            if topPosts.count > 1{
            if let card = self.createCard(Undo: false){
                print("multiple cards")
                self.backCard = card
                self.view.insertSubview(self.backCard!.cardView!, belowSubview: self.frontCard!.cardView!)
                }
            }else if self.topPosts.count == 1 {//}&& firstFetch == false{
                print("1 Card")
                self.backCard = self.frontCard
                print(backCard?.cardView?.card.backgroundColor?.components)
                self.view.insertSubview(self.backCard!.cardView!, belowSubview: self.frontCard!.cardView!)
            }
            
        }
        
        
        
        if(self.indicatorAdded == false){
            self.addCardNumberIndicator()
            self.indicatorAdded = true
        }else{
            self.cardNumberIndicator.text = "\(self.indicatorNumber)/\(self.topPosts.count)"
        }
        
        if(firstFetch == true){
            firstFetch = false
        }
        
        //(topPosts.count)
    }
    
    @objc func reference(){
        ref?.child("Likes").child(category).queryOrderedByValue()/*.queryLimited(toFirst: 1).queryLimited(toLast: 5)*/.observeSingleEvent(of: .value, with: {(snapshot) in
            //self.topPostsNum.removeAll()
            self.topPosts.removeAll()
            if snapshot.childrenCount > 0{
                var array = [String]()
                for Postsdata in snapshot.children.allObjects as! [DataSnapshot] {
                    let key = Postsdata.key
                    array.append(key)
                }
                //let this =
                
                if array.count >= 50 {
                    self.topPostsNum = Array(array[0 ..< 50])
                } else {
                    self.topPostsNum = array
                }
                self.topPostsNum?.reverse()
                
                for postNum in self.topPostsNum!{
                    for Postsdata in snapshot.children.allObjects as! [DataSnapshot] {
                        if(Postsdata.key == postNum){
                            let likes = Postsdata.value as? Int
                            self.likesCountList.append(likes!)
                            
                            
                        }
                    }
                }
                self.ref?.child("PostsData").observeSingleEvent(of: .value, with: {(snapshot) in
                    if(snapshot.childrenCount > 0){
                        for num in self.topPostsNum!{
                            var PostColor: UIColor?
                            for Postsdata in snapshot.children.allObjects as! [DataSnapshot]{
                                let postNum = Postsdata.key
                                if(num == postNum){
                                    print("num: \(num) =? postNum: \(postNum)")
                                    let postObject = Postsdata.value as? [String: AnyObject]
                                    let cardCategory = postObject?["Category"]
                                    let cardTitle = postObject?["Title"]
                                    let cardContent = postObject?["Content"]
                                    let ColorData = Postsdata.childSnapshot(forPath: "Color")
                                    if(ColorData.childrenCount > 0 && ColorData.key == "Color"){
                                        let color = ColorData.value as? [String: CGFloat]
                                        //print(ColorData.key)
                                        let red = color?["red"]
                                        let green = color?["green"]
                                        let blue = color?["blue"]
                                        let alpha = color?["alpha"]
                                        PostColor = UIColor(red: (red)!, green: (green)!, blue: (blue)!, alpha: (alpha)!)
                                    }
                                    let post = CardsData(category: cardCategory as? String, title: cardTitle as? String, content: cardContent as? String, postNum: postNum, color: PostColor)
                                    self.topPosts.append(post)
                                }
                            }
                        }
                    }
                    self.initiateCards()
                })
                
            }
        })
    }
    
    func createCard(Undo: Bool) -> Card?{
        
        if(topPosts.count > 0){
        if !Undo && currentCardNumber < topPosts.count - 1 {
            
            addNextCard()
            
        }else if Undo {
            
            
            addPreviousCard()
        }else{
            
        }
        
        //cardNumberIndicator.text = "\(frontCard?.rank)"
        return Card(cardView: cardView)
        }
         return nil
    }

    func addNextCard(){
        
        if undid {
            currentCardNumber += 1
        }
        if (currentCardNumber == topPosts.count - 1) {
            currentCardNumber = -1
        }
        currentCardNumber += 1
        cardView = SwipableCardView(frame: CardFrame())
        cardView.card.backgroundColor = topPosts[currentCardNumber].color
        cardView.delegate = self
        view.addSubview(cardView)
        cardView.cardCategory.text = topPosts[currentCardNumber].category
        cardView.cardTitle.text = topPosts[currentCardNumber].title
        addRankTab()
        addLikesTab()
        cardView.cardTexts.text = topPosts[currentCardNumber].content
        cardView.cardTexts.backgroundColor = UIColor.clear
        //print("next\(currentCardNumber)")
        undid = false
    }
    
    func addPreviousCard(){
        
        //print("before2: \(currentCardNumber)")
        
        currentCardNumber -= 1
        
        if currentCardNumber == -1 {
            currentCardNumber = topPosts.count - 1
            indicatorNumber = topPosts.count
        }
        cardNumberIndicator.text = "\(indicatorNumber)/\(topPosts.count)"
        //print("after2: \(currentCardNumber)")
        cardView = SwipableCardView(frame: CardFrame())
        view.addSubview(cardView)
        cardView.delegate = self
        addRankTab()
        cardView.cardTitle.text = topPosts[currentCardNumber].title
        cardView.cardCategory.text = topPosts[currentCardNumber].category
        cardView.cardTexts.text = topPosts[currentCardNumber].content
        addLikesTab()
        cardView.transform =  CGAffineTransform(scaleX: 3, y: 3)
        cardView.alpha = 0
        cardView.card.backgroundColor = topPosts[currentCardNumber].color
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func CardFrame() -> CGRect {
        return CGRect(x: view.frame.width*0.05, y: view.frame.height*0.15, width: view.frame.width * 0.9, height: view.frame.height*0.6)
    }
    
    private func addRank(){
        rank = UILabel(frame: CGRect(x: cardView.frame.width*0.025, y: 0, width: cardView.frame.width*0.2, height: cardView.frame.height/20))
        let num = currentCardNumber + 1
        rank.text="Rank: \(num)"
        //print(rank.text)
        rank.numberOfLines = 1
        rank.textColor = UIColor(red:1.00, green:1.00, blue:0.13, alpha:1.0)
        rank.backgroundColor = UIColor.clear
        rank.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        rank.textAlignment = NSTextAlignment.left
        rankTab.addSubview(rank)
        
        //rank.attributedText = NSAttributedString(string: "Rank: 1", attributes: attributes)
    }
    
    private func addLikes(){
        likes = UILabel(frame: CGRect(x: 0, y: 0, width: cardView.frame.width*0.25, height: cardView.frame.height/15))
        likes.text = "likes: \(likesCountList[currentCardNumber])"
        likes.numberOfLines = 1
        likes.textColor = UIColor.red//(red:1.00, green:0.08, blue:0.64, alpha:1.0)
        likes.backgroundColor = UIColor.clear
        likes.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        likes.textAlignment = NSTextAlignment.center
        likesTab.addSubview(likes)
    }
    
    func addRankTab(){
        rankTab = UIView(frame: CGRect(x: cardView.frame.width*0.05, y: -cardView.frame.height/15 + 8, width: cardView.frame.width/4, height: cardView.frame.height/12))
        rankTab.layer.cornerRadius = cardView.frame.height/48
        rankTab.backgroundColor = UIColor.lightGray
        cardView.insertSubview(rankTab, belowSubview: cardView.card)
        addRank()
    }
    
    func addLikesTab(){
        likesTab = UIView(frame: CGRect(x: cardView.frame.width*0.05, y: cardView.frame.height*0.9, width: cardView.frame.width*0.25, height: cardView.frame.height/15))
        likesTab.backgroundColor = .white
        likesTab.layer.cornerRadius =  cardView.frame.height/30
        cardView.addSubview(likesTab)
        addLikes()
    }
    
    func addingUndoButton(){
        UndoButton.frame = CGRect(x: view.frame.width/2 - view.frame.width/16/*view.frame.width/2 - view.frame.width/16*/, y: view.frame.height*0.8, width: view.frame.width/8, height: view.frame.width/8)
        UndoButton.setTitle("", for: .normal)
        UndoButton.center.x = self.view.center.x
        UndoButton.setTitleColor(UIColor.yellow,for: .normal)
        UndoButton.layer.borderWidth = 1
        UndoButton.layer.borderColor = (UIColor.black).cgColor
        UndoButton.backgroundColor = UIColor.black
        UndoButton.tintColor = .white
        UndoButton.setImage(#imageLiteral(resourceName: "redo"), for: .normal)
        UndoButton.layer.cornerRadius = UndoButton.frame.width/2
        UndoButton.addTarget(self, action: #selector(Undo(_:)), for: .touchUpInside)
        view.addSubview(UndoButton)
    }
    
    func addCardNumberIndicator()
    {
        cardNumberIndicator = UILabel(frame: CGRect(x: view.frame.width/2 - view.frame.width/16/*view.frame.width/2 - view.frame.width/16*/, y: view.frame.height*0.9, width: view.frame.width/8, height: view.frame.width/8))
        cardNumberIndicator.text = "1/\(topPosts.count)"
        cardNumberIndicator.center.x = self.view.center.x
        cardNumberIndicator.textColor = UIColor.lightGray
        cardNumberIndicator.textAlignment = .center
        view.addSubview(cardNumberIndicator)
    }
    
    @objc func Undo(_ sender: UIButton)
    {
        sender.pulsate()
        print(currentCardNumber)
        if (topPosts.count > 0) {
            indicatorNumber -= 1
            if(!undid){
                if currentCardNumber == 0{
                    //print("beforeUndid:\(currentCardNumber)")
                    currentCardNumber = topPosts.count
                    indicatorNumber = currentCardNumber
                    // print("afterUndid:\(currentCardNumber)")
                }
                currentCardNumber -= 1
            }
            cardNumberIndicator.text = "\(indicatorNumber)"
            backCard = frontCard
            if let card = self.createCard(Undo: true){
                self.frontCard = card
                self.view.addSubview(self.frontCard!.cardView!)
                undid = true
            }
            UIView.animate(withDuration: 0.5, animations:{
                self.frontCard!.cardView?.transform =  CGAffineTransform(scaleX: 1, y: 1)
                self.frontCard!.cardView?.alpha = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                UIView.animate(withDuration: 0.5, animations:{
                    self.frontCard!.cardView?.transform =  CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.frontCard!.cardView?.alpha = 1
                })
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                UIView.animate(withDuration: 0.5, animations:{
                    self.frontCard!.cardView?.transform =  CGAffineTransform(scaleX: 1, y: 1)
                    self.frontCard!.cardView?.alpha = 1
                })
            })
        }
    }
    
    func switchCards(lastCard: Bool){
        
        print(currentCardNumber)
        indicatorNumber += 1
        if indicatorNumber == topPosts.count + 1{
            indicatorNumber = 1
        }
        if (currentCardNumber == topPosts.count - 1) {
            currentCardNumber = -1
        }
        
        cardNumberIndicator.text = "\(indicatorNumber)/\(topPosts.count)"
        if(!lastCard){
        frontCard = backCard
        }
        
        if let card = self.createCard(Undo: false){
            self.backCard = card
            self.view.insertSubview(self.backCard!.cardView!, belowSubview: self.frontCard!.cardView!)
            
        }
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

extension TopChartVC: SwipableCardViewDelegate {
    func expandInfo() {
        let duration = 0.5

        animate(duration: Float(duration))
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration*4), execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ExpandInfoVC") as! ExpandInfoVC
            vc.bgColor = self.frontCard?.cardView!.card.backgroundColor
            vc.titleText = self.frontCard?.cardView!.cardTitle.text
            vc.categoryText = self.frontCard?.cardView!.cardCategory.text
            vc.contentText = self.frontCard?.cardView!.cardTexts.text
            
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
        brush.backgroundColor = frontCard?.cardView!.card.backgroundColor
        //brush.bringSubview(toFront: (self.tabBarController?.tabBar)!)
    }
    
    func addBrushEffect(brush: UIView,x: CGFloat, y: CGFloat){
        brush.frame = CGRect(x: CGFloat(x), y: y, width: view.frame.width/4, height: view.frame.height)
        brush.alpha = 1
        self.tabBarController?.view.addSubview(brush)
    }
    
    
    func setBacKCardAlpha(alphaNum: Float) {
        if let backCard = backCard{
            backCard.cardView!.alpha = CGFloat(alphaNum)
        }
    }
    
    func swipedLeft() {
        //print("left")
        if frontCard != nil {
            //self.frontCard?.cardView.removeFromSuperview()
            //saveSkip(frontCard.user)
            switchCards(lastCard: false)
        }
    }
    
    func swipedRight() {
        //print("right")
        if frontCard != nil {
            //self.frontCard?.cardView.removeFromSuperview()
            //saveLike(frontCard.user)
            switchCards(lastCard: false)
        }
    }
}

extension TopChartVC{
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

