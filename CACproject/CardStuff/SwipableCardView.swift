
import UIKit

protocol SwipableCardViewDelegate: class{
    func swipedLeft()
    func swipedRight()
    func expandInfo()
}

class SwipableCardView: UIView{
    weak var delegate: SwipableCardViewDelegate?
    
    //@IBOutlet weak var thumbImageView: UIImageView!
    var card = UIView()
    var cardTexts = UILabel()
    var cardTitle = UILabel()
    var cardLine = UIView()
    var cardCategory = UILabel()
    var cardUserFrame = UIView()
    var Indicator = SwipeIndicator()
    var selection: Bool = false
    var ExpandButton: UIButton!
    
    
    var likedList = Array<(cardCategory: String, cardTitle: String, cardContent: String,  cardColor: UIColor)>()
    
    //@IBOutlet weak var cardTexts: UILabel!
    //var cardTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        likedList.removeAll()
        card.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        addSubview(card)
        card.layer.cornerRadius = self.frame.width*0.05
        //Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        //self.autoresizin2gMask = [.flexibleHeight,.flexibleWidth]
        //self.
        let gesture = UIPanGestureRecognizer(target: self, action:(#selector(swipingCard)))
        self.addGestureRecognizer(gesture)
        
        //content
        cardTexts = UILabel(frame: CGRect(x: self.frame.width*0.05, y: self.frame.height*0.2, width: self.frame.width*0.9, height: self.frame.height*0.65))
        cardTexts.text="Sample"
        cardTexts.font = UIFont.systemFont(ofSize: self.frame.height*0.75/14, weight: UIFont.Weight.regular)
        cardTexts.numberOfLines = 0
        cardTexts.backgroundColor = UIColor.clear
        cardTexts.textColor = UIColor.white
        card.addSubview(cardTexts)
        Indicator = SwipeIndicator(frame: CGRect(x: self.frame.width/4, y: (self.frame.height-self.frame.width/2)/2, width: self.frame.width/2, height: self.frame.width/2))
        //thumbImageView = UIImageView(image: #imageLiteral(resourceName: "thumbUp"))
        card.addSubview(Indicator)
        //thumbImageView.tintColor = UIColor.red
        Indicator.alpha = 0
        Indicator.transform = CGAffineTransform(rotationAngle: -3.14159265/6)
       // thumbImageView.isHidden = false
        
        //User Image and name
        
        
        //self.addConstraint(leadingConstraints,topConstraints,bottomConstraints,trailingConstraints)

        
        
        //line
        cardLine = UIView(frame: CGRect(x: self.frame.width*0.025, y: self.frame.height*0.2/*-self.frame.height/20*/, width: self.frame.width*0.95, height: 3))
        cardLine.backgroundColor = UIColor.black
        cardLine.alpha = 0.1
        cardLine.layer.cornerRadius = cardLine.frame.height/2
        card.addSubview(cardLine)
        
        //category
        cardCategory = UILabel(frame: CGRect(x: self.frame.width*0.05, y: 0, width: self.frame.width*0.9, height: self.frame.height/15))
        cardCategory.text="category"
        cardCategory.numberOfLines = 1
        cardCategory.textColor = UIColor.white
        cardCategory.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        cardCategory.textAlignment = NSTextAlignment.right
        card.addSubview(cardCategory)
        
        //title
        cardTitle = UILabel(frame: CGRect(x: self.frame.width*0.05, y: self.frame.height*0.2-self.frame.height/10, width: self.frame.width*0.9, height: self.frame.height/10))
        cardTitle.text="This is a title"
        cardTitle.numberOfLines = 1
        cardTitle.textColor = UIColor.white
        cardTitle.font = UIFont.systemFont(ofSize: self.frame.height*0.75/14, weight: UIFont.Weight.semibold)
        card.addSubview(cardTitle)
        
        
        //thumbImageView.tintColor = UIColor.clear;
        ExpandButton = UIButton(frame: CGRect(x: card.frame.width/2 - 15, y: card.frame.height - 30, width: 30, height: 30))
        ExpandButton.setBackgroundImage(#imageLiteral(resourceName: "expand"), for: .normal)
        ExpandButton.tintColor = .white
        //ExpandButton.backgroundColor = .white
        card.addSubview(ExpandButton)
        ExpandButton.addTarget(self, action: #selector(expand(_:)), for: .touchUpInside)
        
    }
    
    @objc func expand(_ sender: UIButton){
        if let d = self.delegate{
            d.expandInfo()
        }
    }
    
    ///////////////Card Swiping Section
    
    @objc func swipingCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let movement = sender.translation(in: superview)
        let centerY = (self.superview?.frame.height)!*0.15 + (self.superview?.frame.height)!*0.6/2
        let xFromCenter  = self.center.x - (superview?.center.x)!
        card.center = CGPoint(x: (superview?.center.x)! + movement.x, y: centerY + movement.y)
        
        /* if let d = self.delegate{
         d.setBacKCardAlpha(alphaNum: Float(xFromCenter/(superview?.center.x)!))
         }*/
        
        card.transform = CGAffineTransform(rotationAngle: 0.61*(xFromCenter/(superview?.center.x)!)).scaledBy(x: 1-0.3*(abs(xFromCenter)/(superview?.center.x)!), y: 1-0.3*(abs(xFromCenter)/(superview?.center.x)!))
        
        //////////////Might be useful some times
        if(selection == true)
        {
         if xFromCenter > 0{
         //to the right
         Indicator.Indicator.text = "GOOD IDEA"
         Indicator.transform = CGAffineTransform(rotationAngle: 3.14159265/6)
         Indicator.Indicator.backgroundColor = UIColor.green
         Indicator.ShadowLayer.backgroundColor = UIColor.green
         }else if xFromCenter < 0{
         //to the left
         Indicator.Indicator.text = "BAD IDEA"
         Indicator.transform = CGAffineTransform(rotationAngle: -3.14159265/6)
         Indicator.Indicator.backgroundColor = UIColor.red
         Indicator.ShadowLayer.backgroundColor = UIColor.red
         }else
         {
            Indicator.alpha = 0
         }
         Indicator.alpha = abs(xFromCenter)/((superview?.frame.width)!/2)*2
         //print(abs(xFromCenter)/((superview?.frame.width)!/2))
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < (superview?.frame.width)!*0.2{
                //move off to the left
                disLike(isButton: false)
                return
            }else if card.center.x > (superview?.frame.width)!*0.8 {
                //move off to the right
                like(isButton: false)
                return
            }else{
                resetCard()
            }
        }
    }
    
    func resetCard(){
        UIView.animate(withDuration: 0.3, animations:{
            
            let centerY = (self.superview?.frame.height)!*0.15 + (self.superview?.frame.height)!*0.6/2
            self.center = CGPoint(x: (self.superview?.center.x)!, y: centerY/*((self.superview?.frame.height)!)*/)
            self.alpha = 1
            self.Indicator.alpha = 0
            self.transform = CGAffineTransform.identity
        })
    }
    
    func disLike(isButton: Bool){
        
        if(isButton){
            self.Indicator.Indicator.text = "BAD IDEA"
            self.Indicator.transform = CGAffineTransform(rotationAngle: -3.14159265/6)
            self.Indicator.Indicator.backgroundColor = UIColor.red
            self.Indicator.ShadowLayer.backgroundColor = UIColor.red
            UIView.animate(withDuration: 0.3, animations: {
                self.Indicator.alpha = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                UIView.animate(withDuration: 0.5, animations:{
                    self.center = CGPoint(x: self.center.x - 200, y: self.center.y+50)
                    self.alpha = 0
                    self.transform = CGAffineTransform(rotationAngle: 0.61*(self.center.x - (self.superview?.frame.width)!/2)/(self.superview?.center.x)!).scaledBy(x: 1-0.3*(abs(self.center.x - (self.superview?.frame.width)!/2)/(self.superview?.center.x)!), y: 1-0.3*(abs(self.center.x - (self.superview?.frame.width)!/2)/(self.superview?.center.x)!))
                }, completion: { finished in
                    if let d = self.delegate{
                        d.swipedRight()
                    }
                })
            })
        }else{
        UIView.animate(withDuration: 0.5, animations:{
            self.center = CGPoint(x: self.center.x - 200, y: self.center.y+50)
            self.alpha = 0
        }, completion: { finished in
            if let d = self.delegate{
                d.swipedLeft()
            }
            })
        }
        
    }
    
    func like(isButton: Bool){
        
        if(isButton){
            
            self.Indicator.Indicator.text = "GOOD IDEA"
            self.Indicator.transform = CGAffineTransform(rotationAngle: 3.14159265/6)
            self.Indicator.Indicator.backgroundColor = UIColor.green
            self.Indicator.ShadowLayer.backgroundColor = UIColor.green
            UIView.animate(withDuration: 0.3, animations: {
                self.Indicator.alpha = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                UIView.animate(withDuration: 0.5, animations:{
                    self.center = CGPoint(x: self.center.x + 200, y: self.center.y+75)
                    self.alpha = 0
                    self.transform = CGAffineTransform(rotationAngle: 0.61*(self.center.x - (self.superview?.frame.width)!/2)/(self.superview?.center.x)!).scaledBy(x: 1-0.3*(abs(self.center.x - (self.superview?.frame.width)!/2)/(self.superview?.center.x)!), y: 1-0.3*(abs(self.center.x - (self.superview?.frame.width)!/2)/(self.superview?.center.x)!))
                }, completion: { finished in
                    if let d = self.delegate{
                        d.swipedRight()
                    }
                })
            })
        }else{
        UIView.animate(withDuration: 0.5, animations:{
            self.center = CGPoint(x: self.center.x + 200, y: self.center.y+75)
            self.alpha = 0
        }, completion: { finished in
            if let d = self.delegate{
                d.swipedRight()
            }
        })
        }
        
    }
    
    
    
   
    
    func addToLiked(cardText: String, cardTitle: String, cardCategory: String, cardColor: UIColor){
    //print("sent")
    let likedCard = (cardColor: cardColor, cardTitle: cardTitle, cardContent: cardText, cardCategory: cardCategory)
    likedList.insert(likedCard, at: 0)
    //UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: likedList), forKey: "likedList")
    }
}



class SwipeIndicator: UIView{
    
    var Indicator: UILabel!
    var ShadowLayer: UIView!
    var InnerCircle: UIView!
    var OutterCircle: UIView!
    var SmallCircle: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        IndicatorInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        IndicatorInit()
    }
    
    private func IndicatorInit(){
        
        /*SmallCircle = UIView(frame: CGRect(x: 10, y: 10, width: self.frame.width-20, height: self.frame.width - 20))
        SmallCircle.backgroundColor = UIColor.white
        SmallCircle.layer.borderColor = UIColor.red.cgColor
        SmallCircle.layer.cornerRadius = (self.frame.width-20)/2
        SmallCircle.layer.borderWidth = 3
        addSubview(SmallCircle)
        
        
        OutterCircle = UIView(frame: CGRect(x: self.frame.width/6, y: self.frame.width/6, width: self.frame.width*2/3, height: self.frame.width*2/3))
        OutterCircle.backgroundColor = UIColor.white
        OutterCircle.layer.borderColor = UIColor.red.cgColor
        OutterCircle.layer.cornerRadius = self.frame.width/3
        OutterCircle.layer.borderWidth = 4
        self.addSubview(OutterCircle)
        
        
        InnerCircle = UIView(frame: CGRect(x: self.frame.width*2/10, y: self.frame.width*2/10, width: self.frame.width*3/5, height: self.frame.width*3/5))
        InnerCircle.backgroundColor = UIColor.white
        InnerCircle.layer.borderColor = UIColor.red.cgColor
        InnerCircle.layer.cornerRadius = self.frame.width*3/10
        InnerCircle.layer.borderWidth = 2
        self.addSubview(InnerCircle)*/
        
        
        ShadowLayer = UIView(frame: CGRect(x: -6, y: (self.frame.height-self.frame.width/4)/2-6, width: self.frame.width+12, height: self.frame.width/4+12))
        ShadowLayer.backgroundColor = UIColor.red
        ShadowLayer.layer.cornerRadius = (self.frame.width/4+12)/10
        ShadowLayer.layer.borderColor = UIColor.white.cgColor
        ShadowLayer.layer.borderWidth = 4
        self.addSubview(ShadowLayer)
        //thumbImageView = UIImageView(image: #imageLiteral(resourceName: "thumbUp"))
        
        
        Indicator = UILabel(frame: CGRect(x: 0, y: (self.frame.height-self.frame.width/4)/2, width: self.frame.width, height: self.frame.width/4))
        Indicator.backgroundColor = .red
        Indicator.text = "GOOD IDEA"
        Indicator.font = UIFont.systemFont(ofSize: self.frame.width/6, weight: UIFont.Weight.heavy)
        Indicator.textColor = UIColor.white
        Indicator.textAlignment = .center
        Indicator.layer.borderColor = UIColor.white.cgColor
        Indicator.layer.borderWidth = 3
        Indicator.layer.cornerRadius = self.frame.width/40
        self.backgroundColor  = .clear
        self.addSubview(Indicator)
    }
}
