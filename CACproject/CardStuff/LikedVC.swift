
//  TopChartVC.swift
//  Congressional
//
//  Created by user on 10/18/17.
//  Copyright © 2017 Martinia. All rights reserved.
//

import UIKit
import Firebase

class LikedVC: UIViewController {
    
    var topPosts = [Int]()
    
    var getCardList = SwipableCardView()
    
    //var cardInfoList = Array<(cardCategory: String, cardTitle: String, cardContent: String,  cardColor: UIColor)>()
    
    var currentCardNumber:Int = -1
    
    struct Card {
        var cardView = SwipableCardView()
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
    var brush1 = UIView()
    var brush2 = UIView()
    var brush3 = UIView()
    var brush4 = UIView()
    
    var ref: DatabaseReference?
    var likedList = [CardsData]()
    var likesCountlist = [Int]()
    
    override func viewDidLoad() {
        /*
        for i in 1...10{
            topPosts.append(i)
            //print(i)
        }
        */
        
        //topPosts.append(1)
        //cardInfoList.insert(getCardList.likedList[1].cardCategory, at: 0)
        /*if var likedList = UserDefaults.standard.object(forKey: "likedList") as? NSData
        {
            likedList = NSKeyedUnarchiver.unarchiveObject(with: likedList as Data) as! NSData
            //cardInfoList = likedList as! [(cardCategory: String, cardTitle: String, cardContent: String, cardColor: UIColor)]
        }*/
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
        
        
        ref?.child("PostsData").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                let defaults = UserDefaults.standard
                let userLiked = defaults.object(forKey: "userLikedList") as? [String]
                if(userLiked != nil){
                for liked in userLiked!{
            for Postsdata in snapshot.children.allObjects as! [DataSnapshot]{
                let postNum = Postsdata.key
                if(postNum == liked){
                    let postObject = Postsdata.value as? [String: AnyObject]
                    let cardCategory = postObject?["Category"]
                    let cardTitle = postObject?["Title"]
                    let cardContent = postObject?["Content"]
                    let post = CardsData(category: cardCategory as? String, title: cardTitle as? String, content: cardContent as? String, postNum: postNum)
                    self.likedList.append(post)
                }
            }
                    }}
            
            self.ref?.child("Likes").observe(.value, with: {(snapshot) in
                for Postsdata in snapshot.children.allObjects as! [DataSnapshot]{
                    if(userLiked != nil){
                    for liked in userLiked!{
                    for postsNumber in Postsdata.children.allObjects as! [DataSnapshot]{
                    let postNum = postsNumber.key
                    if(postNum == liked){
                        let likes = postsNumber.value as? Int
                        self.likesCountlist.append(likes!)
                    }
                    }
                }
                    }
                }
                
                if let card = self.createCard(Undo: false){
                    self.frontCard = card
                    self.view.addSubview(self.frontCard!.cardView)
                }
                
                if let card = self.createCard(Undo: false){
                    self.backCard = card
                    self.view.insertSubview(self.backCard!.cardView, belowSubview: self.frontCard!.cardView)
                }
                
                if  self.likesCountlist.count == 1 {
                    print("1 Card")
                    self.backCard = self.frontCard
                    self.view.insertSubview(self.backCard!.cardView, belowSubview: self.frontCard!.cardView)
                }
                
                self.addCardNumberIndicator()
            })
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(LikedVC.Unbrush), name:NSNotification.Name(rawValue: "NotificationID"), object: nil)
        addingUndoButton()
        
        // Do any additional setup after loading the view.
    }
    
    func createCard(Undo: Bool) -> Card?{
        
        if(likedList.count != 0){
        if !Undo && currentCardNumber < likedList.count - 1 {
            
            addNextCard()
            
        }else if Undo {
            
            
            addPreviousCard()
        }else{
            
            return nil
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
        if (currentCardNumber == likedList.count - 1) {
            currentCardNumber = -1
        }
        currentCardNumber += 1
        cardView = SwipableCardView(frame: CardFrame())
        cardView.card.backgroundColor = getRandomColor()
        cardView.delegate = self
        view.addSubview(cardView)
        cardView.cardCategory.text = likedList[currentCardNumber].category
        cardView.cardTitle.text = likedList[currentCardNumber].title
        //addRankTab()
        addLikesTab()
        cardView.cardTexts.text = likedList[currentCardNumber].content
        //cardView.cardTexts.backgroundColor = cardInfoList[currentCardNumber].cardColor
        //print("next\(currentCardNumber)")
        undid = false
    }
    
    func addPreviousCard(){
        
        //print("before2: \(currentCardNumber)")
        currentCardNumber -= 1
        if currentCardNumber == -1 {
            currentCardNumber = likedList.count - 1
            indicatorNumber = likedList.count
        }
        cardNumberIndicator.text = "\(indicatorNumber)/\(likedList.count)"
        //print("after2: \(currentCardNumber)")
        cardView = SwipableCardView(frame: CardFrame())
        view.addSubview(cardView)
        cardView.delegate = self
        //addRankTab()
        cardView.cardTitle.text = likedList[currentCardNumber].title
        cardView.cardCategory.text = likedList[currentCardNumber].category
        cardView.cardTexts.text = likedList[currentCardNumber].content
        addLikesTab()
        cardView.transform =  CGAffineTransform(scaleX: 3, y: 3)
        cardView.alpha = 0
        cardView.card.backgroundColor = getRandomColor()
        
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
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
        if(likesCountlist.count > 0){
        likes.text = "likes: \(likesCountlist[currentCardNumber])"
        }
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
        UndoButton.frame = CGRect(x: view.frame.width/3 - view.frame.width/16/*view.frame.width/2 - view.frame.width/16*/, y: view.frame.height*0.8, width: view.frame.width/8, height: view.frame.width/8)
        UndoButton.setTitle("", for: .normal)
        UndoButton.setTitleColor(UIColor.yellow,for: .normal)
        UndoButton.backgroundColor = UIColor.green
        UndoButton.layer.cornerRadius = UndoButton.frame.width/2
        UndoButton.addTarget(self, action: #selector(Undo(_:)), for: .touchUpInside)
        view.addSubview(UndoButton)
    }
    
    func addCardNumberIndicator()
    {
        cardNumberIndicator = UILabel(frame: CGRect(x: view.frame.width/2 - view.frame.width/16/*view.frame.width/2 - view.frame.width/16*/, y: view.frame.height*0.8, width: view.frame.width/8, height: view.frame.width/8))
        cardNumberIndicator.text = "1/\(likedList.count)"
        cardNumberIndicator.textColor = UIColor.lightGray
        cardNumberIndicator.textAlignment = .center
        view.addSubview(cardNumberIndicator)
    }
    
    @objc func Undo(_ sender: UIButton)
    {
        sender.pulsate()
        if (likedList.count > 0) {
        indicatorNumber -= 1
        if(!undid){
            if currentCardNumber == 0{
                //print("beforeUndid:\(currentCardNumber)")
                currentCardNumber = likedList.count
                
                // print("afterUndid:\(currentCardNumber)")
            }
            currentCardNumber -= 1
        }
        cardNumberIndicator.text = "\(indicatorNumber)"
        backCard = frontCard
        if let card = self.createCard(Undo: true){
            self.frontCard = card
            self.view.addSubview(self.frontCard!.cardView)
            undid = true
        }
        UIView.animate(withDuration: 0.5, animations:{
            self.frontCard!.cardView.transform =  CGAffineTransform(scaleX: 1, y: 1)
            self.frontCard!.cardView.alpha = 1
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.animate(withDuration: 0.5, animations:{
                self.frontCard!.cardView.transform =  CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.frontCard!.cardView.alpha = 1
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.animate(withDuration: 0.5, animations:{
                self.frontCard!.cardView.transform =  CGAffineTransform(scaleX: 1, y: 1)
                self.frontCard!.cardView.alpha = 1
            })
        })
    }
    }
    
    func switchCards(lastCard: Bool){
        
        print(currentCardNumber)
        indicatorNumber += 1
        if indicatorNumber == likedList.count + 1{
            indicatorNumber = 1
        }
        if (currentCardNumber == likedList.count - 1) {
            currentCardNumber = -1
        }
        
        cardNumberIndicator.text = "\(indicatorNumber)/\(likedList.count)"
        if(!lastCard){
            frontCard = backCard
        }
        
        if let card = self.createCard(Undo: false){
            self.backCard = card
            self.view.insertSubview(self.backCard!.cardView, belowSubview: self.frontCard!.cardView)
            
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

extension LikedVC: SwipableCardViewDelegate {
    func expandInfo() {
        let duration = 0.5
        addBrushEffect(brush: brush1, x: 0, y: -view.frame.height)
        addBrushEffect(brush: brush2, x: view.frame.width/4 ,y: view.frame.height*2)
        addBrushEffect(brush: brush3, x: view.frame.width/2 ,y: -view.frame.height)
        addBrushEffect(brush: brush4, x: view.frame.width*3/4 ,y: view.frame.height*2)
        
        animate(duration: Float(duration))
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration*4), execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ExpandInfoVC") as! ExpandInfoVC
            vc.bgColor = self.frontCard?.cardView.card.backgroundColor
            vc.titleText = self.frontCard?.cardView.cardTitle.text
            vc.categoryText = self.frontCard?.cardView.cardCategory.text
            vc.contentText = self.frontCard?.cardView.cardTexts.text
            
            self.present(vc, animated: false, completion: nil)
            //self.brush4.removeFromSuperview()
        })
        
    }
    
    func animate(duration: Float){
        brush1.alpha = 1
        brush2.alpha = 1
        brush3.alpha = 1
        brush4.alpha = 1
        print(duration)
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.brush1.center = CGPoint(x: self.view.frame.width/8,y: self.view.frame.height/2)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration) - 0.2, execute: {
            UIView.animate(withDuration: TimeInterval(duration)+0.1, animations: {
                self.brush2.center = CGPoint(x: self.view.frame.width/4+self.view.frame.width/8,y: self.view.frame.height/2)
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration*2) - 0.14, execute: {
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                self.brush3.center = CGPoint(x: self.view.frame.width/2 + self.view.frame.width/8,y: self.view.frame.height/2)
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration*3) - 0.27, execute: {
            UIView.animate(withDuration: TimeInterval(duration+0.1), animations: {
                self.brush4.center = CGPoint(x: self.view.frame.width*3/4 + self.view.frame.width/8 ,y: self.view.frame.height/2)
            })
        })
        
    }
    
    func addBrushEffect(brush: UIView,x: CGFloat, y: CGFloat){
        brush.frame = CGRect(x: CGFloat(x), y: y, width: view.frame.width/4, height: view.frame.height)
        brush.alpha = 0
        brush.backgroundColor = frontCard?.cardView.card.backgroundColor
        view.addSubview(brush)
    }
    
    func setBacKCardAlpha(alphaNum: Float) {
        if let backCard = backCard{
            backCard.cardView.alpha = CGFloat(alphaNum)
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

extension LikedVC{
    @objc public func Unbrush() {
        //self.brush4.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                self.brush4.center = CGPoint(x: self.view.frame.width*3/4 + self.view.frame.width/8 ,y: self.view.frame.height*3/2)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.brush3.center = CGPoint(x: self.view.frame.width/2 + self.view.frame.width/8,y: -self.view.frame.height/2)
                })
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.brush2.center = CGPoint(x: self.view.frame.width/4+self.view.frame.width/8,y: self.view.frame.height*3/2)
                })
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.brush1.center = CGPoint(x: self.view.frame.width/8,y: -self.view.frame.height/2)
                })
            })
        })
    }
}
