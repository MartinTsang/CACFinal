//
//  ExpandInfoVC.swift
//  Congressional
//
//  Created by user on 10/21/17.
//  Copyright © 2017 Martinia. All rights reserved.
//

import UIKit

protocol expandInfoDelegate: class {
    func Unbrush()
}

class ExpandInfoVC: UIViewController {

    weak var delegate: expandInfoDelegate?
    var bgColor: UIColor!
    var button = UIButton()
    var titleText: String!
    var contentText: String!
    var categoryText: String!
    var cardTitle: UILabel!
    var cardContent: UILabel!
    var cardCategory: UILabel!
    var scroll = UIScrollView()
    var navBar = UIView()
    var whitePaint1 = UIView()
    var whitePaint2 = UIView()
    var whitePaint3 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyPaint(whitePaint: whitePaint1, x: -view.frame.width, y: 0)
        applyPaint(whitePaint: whitePaint2, x: view.frame.width, y: view.frame.height/3)
        applyPaint(whitePaint: whitePaint3, x: -view.frame.width, y: view.frame.height*2/3)
        view.backgroundColor = bgColor
        
        navBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height*0.07)
        view.addSubview(navBar)
        navBar.backgroundColor = .black
        navBar.alpha = 0
        scroll.frame = CGRect(x: 0, y: navBar.frame.height, width: view.frame.width, height: view.frame.height)
        view.addSubview(scroll)
        scroll.backgroundColor = .clear
        
        //
        button = UIButton(frame: CGRect(x: view.frame.width*0.025, y: navBar.frame.height/2, width: view.frame.width*0.12, height: navBar.frame.height/3))
        button.backgroundColor = .clear
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        //
        cardTitle = UILabel(frame: CGRect(x: view.frame.width*0.05, y: 5, width: view.frame.width*0.9, height: view.frame.height*0.1))
        cardTitle.text = titleText
        cardTitle.textColor = .white
        cardTitle.alpha = 0
        cardTitle.font =  UIFont.systemFont(ofSize: view.frame.width*0.07, weight: UIFont.Weight.bold)
        scroll.addSubview(cardTitle)
        
        cardCategory = UILabel(frame: CGRect(x: view.frame.width - view.frame.width/2 - 10, y: -5, width: view.frame.width/2, height: view.frame.height*0.06))
        cardCategory.text = categoryText
        cardCategory.textAlignment = .right
        cardCategory.textColor = .white
        cardCategory.alpha = 1
        scroll.addSubview(cardCategory)
        
        cardContent = UILabel(frame: CGRect(x: view.frame.width*0.05, y: view.frame.height*0.1, width: view.frame.width*0.9, height: view.frame.height))
        cardContent.font = UIFont.systemFont(ofSize: view.frame.width*0.06, weight: UIFont.Weight.regular)
        //label.frame.size =  CGSize(width: view.frame.width, height: view.frame.height)
        cardContent.textColor = .white
        cardContent.numberOfLines = 0
        cardContent.alpha = 1
        cardContent.text = contentText
        cardContent.sizeToFit()
        //cardContent. = .
        scroll.addSubview(cardContent)
        scroll.contentSize = CGSize(width: 0,height: cardContent.frame.height + cardTitle.frame.height + view.frame.height*0.12)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.navBar.alpha = 0.15
            self.button.alpha = 1
            self.cardTitle.alpha = 1
            self.cardCategory.alpha = 1
            self.cardContent.alpha = 1
        })
        //cardContent.animate(newText: contentText, characterDelay: 0.025)
        /*
        UIView.animate(withDuration: 0.5) {
            //self.whitePaint.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            self.whitePaint1.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/6)
            self.whitePaint2.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            self.whitePaint3.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height*5/6)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.animate(withDuration: 0.5) {
                self.whitePaint1.alpha = 0
                self.whitePaint2.alpha = 0
                self.whitePaint3.alpha = 0
                self.navBar.alpha = 0.15
                self.button.alpha = 1
                self.cardTitle.alpha = 1
                self.cardCategory.alpha = 1
                self.cardContent.alpha = 1
            }
        })
 */
        
    }
    
    func applyPaint(whitePaint: UIView, x: CGFloat, y: CGFloat){
        whitePaint.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: view.frame.width, height: view.frame.height/3)
        whitePaint.alpha = 1
        whitePaint.backgroundColor = .white
        view.addSubview(whitePaint)
    }
    
    /*
    func paintAnimate(){
        UIView.animate(withDuration: 0.5, animations: {
            self.brush1.center = CGPoint(x: self.view.frame.width/8,y: self.view.frame.height/2)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                self.brush2.center = CGPoint(x: self.view.frame.width/4+self.view.frame.width/8,y: self.view.frame.height/2)
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            UIView.animate(withDuration: 0.5), animations: {
                self.brush3.center = CGPoint(x: self.view.frame.width/2 + self.view.frame.width/8,y: self.view.frame.height/2)
            })
        })
    }*/
    
    @objc func buttonClicked(_ sender: UIButton){
        
        UIView.animate(withDuration: 0.4, animations: {
            self.navBar.backgroundColor = self.bgColor
            self.button.setTitleColor(self.bgColor, for: .normal)
            self.cardCategory.alpha = 0
            self.cardTitle.alpha = 0
            self.cardContent.alpha = 0
            self.navBar.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.dismiss(animated: false, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
