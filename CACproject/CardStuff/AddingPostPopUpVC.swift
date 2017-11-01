//
//  AddingPostPopUpVC.swift
//  Congressional
//
//  Created by user on 10/16/17.
//  Copyright © 2017 Martinia. All rights reserved.
//

import MaterialColorPicker
//import ChromaColorPicker
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase


class AddingPostPopUpVC: UIViewController /*ChromaColorPickerDelegate*/{
   
    /*
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        changeColorButton.backgroundColor = colorPicker.currentColor
        card.backgroundColor = color
        colorPicker.removeFromSuperview()
        colorView.removeFromSuperview()
        endEditingButton.removeFromSuperview()
    }
    */
    
    var numOfPosts = 0
    var contentView: UITextView!
    var topBar = UIView()
    var backButton = UIButton()
    var sendButton = UIButton()
    var titleField = UITextField()
    var colorView = UIView()
    var colorPicker: MaterialColorPicker!
    var changeColorButton = UIButton()
    var endEditingButton = UIButton()
    var card = UIView()
    var currentColorComponents = [String: Float]()
    var currentColor = UIColor.lightGray
    var currentTitle:String = ""
    var currentContent:String = ""
    var currentCategory:String = ""
    let categorytitles = CategoryTitles()
    var categoryTitles = [Categories]()
    var categoryButton = UIButton()
    var categoryView = UITableView()
    var categoryEndEditingButton: UIButton!
    
    var lastPostRef: DatabaseReference?
    var ref:DatabaseReference?
    var UserReference:DatabaseReference?
    var numberOfLastPost: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTitles = categorytitles.categoryTitles
        ref = Database.database().reference()
        /*
        Auth.auth().signInAnonymously(completion: { (user: User?, error) in
            if error != nil {
                print(error as Any)
                return
            }
            let uid = user?.uid
            self.UserReference = self.ref?.child("users").child(uid!)
        })
        */
        
        ref?.child("PostsData").queryOrderedByKey().queryLimited(toLast: 1).observe(.value , with: { (snapshot) in
            //if(object?.keys){
            //self.numberOfLastPost =
            for Postsdata in snapshot.children.allObjects as! [DataSnapshot]{
                self.numberOfLastPost = Postsdata.key
                print("hi" + self.numberOfLastPost!)
            }
            //}
        })
        
        ref?.child("PostsData").observe(.value, with: {(snapshot: DataSnapshot!) in
            self.numOfPosts = Int(snapshot.childrenCount) + 1
            //print("dataBasenum : \(self.numOfPosts)")
        })
        
        topBar = UIView(frame: CGRect(x: -2, y: -2, width: view.frame.width + 4, height: view.frame.height*0.1 + 2))
        topBar.backgroundColor = UIColor.clear
        topBar.layer.borderColor = UIColor.black.cgColor
        topBar.layer.borderWidth = 0.5
        view.addSubview(topBar)
        let navBarTitle = UILabel()
        navBarTitle.text = "New Post"
        topBar.addSubview(navBarTitle)
        navBarTitle.backgroundColor = .clear
        navBarTitle.textAlignment = .center
        navBarTitle.font = UIFont.systemFont(ofSize: topBar.frame.height/4, weight: UIFont.Weight.semibold)
        navBarTitle.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .left, relatedBy: .equal, toItem: topBar, attribute: .left, multiplier: 1, constant: view.frame.width/2-topBar.frame.height/1)
        let rightConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .right, relatedBy: .equal, toItem: topBar, attribute: .right, multiplier: 1, constant: -view.frame.width/2+topBar.frame.height/1)
        let topConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .top, relatedBy: .equal, toItem: topBar, attribute: .top, multiplier: 1, constant: topBar.frame.height/4+8)
        let bottomConstraints = NSLayoutConstraint(item: navBarTitle, attribute: .bottom, relatedBy: .equal, toItem: topBar, attribute: .bottom, multiplier: 1, constant: -topBar.frame.height/4+10)
        topBar.addConstraints([leftConstraints,rightConstraints,topConstraints,bottomConstraints])
        
        addChangColorButton()
        
        addCard()
        addContentView()
        NotificationCenter.default.addObserver(self, selector: #selector(AddingPostPopUpVC.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddingPostPopUpVC.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        addTitle()
        addLine()
        
        addPostButton()
        addSendButton()
        addCategory()
        
        categoryView.isHidden = true
        //self.titleView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        currentTitle = titleField.text!
        currentContent = contentView.text!
        self.titleField.resignFirstResponder()
        self.contentView.resignFirstResponder()
        
    }
    
    func addChangColorButton(){
        changeColorButton = UIButton(frame: CGRect(x: view.frame.width/4, y: view.frame.height*0.89, width: view.frame.width/2, height: view.frame.width/8))
        changeColorButton.setTitle("Change Color", for: .normal)
        changeColorButton.titleLabel?.font = UIFont.systemFont(ofSize: (view.frame.width/8)/3, weight: UIFont.Weight.bold)
        changeColorButton.setTitleColor(UIColor.white, for: .normal)
        changeColorButton.backgroundColor = UIColor.lightGray
        changeColorButton.layer.cornerRadius = view.frame.width/16
        view.addSubview(changeColorButton)
        changeColorButton.addTarget(self, action: #selector(testPopUP(_:)), for: .touchUpInside)
    }
    
    func addCard(){
        card = UIView(frame: CGRect(x: view.frame.width*0.05, y: view.frame.height*0.15, width: view.frame.width*0.9, height: view.frame.height*0.7))
        card.backgroundColor = UIColor.lightGray
        card.layer.cornerRadius = 10
        view.addSubview(card)
    }
    
    
    
    @objc func testPopUP(_ sender: UIButton){
        sender.pulsate()
        picker()
        UIView.animate(withDuration: 0.5, animations: {
            self.endEditingButton.alpha = 1
            self.colorPicker.alpha = 1
        }, completion: nil)
    }
    
    func addLine(){
        let line = UIView(frame: CGRect(x: card.frame.width*0.025, y: card.frame.height*0.15, width: card.frame.width*0.95, height: 3))
        line.backgroundColor = UIColor.black
        line.alpha = 0.1
        card.addSubview(line)
        
    }
/*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        //self.titleView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Gimme a title plz" {
        textView.text = ""
            textView.textColor = UIColor.white
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.characters.count == 0){
        textView.textColor = UIColor.lightGray
        textView.text = "Gimme a title plz"
        }
        
    }
 */
    
    
    
    /*@objc func setBackground(picker: ChromaColorPicker!){
        colorView.backgroundColor = picker.currentColor
    }
*/
    
    

/*
    func addTitle(){
        /*titleView = TitleView(frame: CGRect(x: 0, y: view.frame.height*0.1, width: view.frame.width, height: view.frame.height*0.1))
        titleView.backgroundColor = UIColor.black
        
        view.addSubview(titleView)
 */
        
        titleView = UITextView(frame: CGRect(x: view.frame.width*0.05, y: view.frame.height*0.12, width: view.frame.width*0.9, height: view.frame.height*0.1))x
        titleView.backgroundColor = UIColor.black
        titleView.textColor = UIColor.lightGray
        //titleView.textAlignment = NSTextAlignment.justified
        //titleView.
        titleView.text = "Gimme a title plz"
        view.addSubview(titleView)
 */
    
//////////////The two Buttons
    func addSendButton()
    {
        addButton(button: backButton, text: "Back", left: 10, right: -(view.frame.width-15-topBar.frame.height/2), top: topBar.frame.height/4+8, bot:  -topBar.frame.height/4+5)
    }
    
    func addPostButton()
    {
        addButton(button: sendButton,text: "Send", left: view.frame.width-15-topBar.frame.height/2, right: -10, top: topBar.frame.height/4+8, bot:  -topBar.frame.height/4+5)
    }
    
    func addButton(button: UIButton, text: String, left: CGFloat, right: CGFloat, top: CGFloat, bot: CGFloat){
        button.setTitle(text, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: topBar.frame.height/4, weight: UIFont.Weight.thin)
        button.backgroundColor=UIColor.clear
        topBar.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let leftConstraints = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: topBar, attribute: .left, multiplier: 1, constant: left)
        let rightConstraints = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: topBar, attribute: .right, multiplier: 1, constant: right)
        let topConstraints = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: topBar, attribute: .top, multiplier: 1, constant: top)
        let bottomConstraints = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: topBar, attribute: .bottom, multiplier: 1, constant: bot)
        topBar.addConstraints([leftConstraints,rightConstraints,topConstraints,bottomConstraints])
        print(topBar.frame.height-top-bot)
        button.titleLabel?.font = UIFont.systemFont(ofSize: (topBar.frame.height-top-bot)/4, weight: UIFont.Weight.bold)
        if(text == ("Back"))
        {
            button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        }else if(text == "Send"){
            button.addTarget(self, action: #selector(send(_:)), for: .touchUpInside)
        }
        return
    }
    
    @objc func send(_ sender: UIButton){
        if(currentTitle.replacingOccurrences(of: " ", with: "") == "" || currentContent.replacingOccurrences(of: " ", with: "") == "" || currentContent.replacingOccurrences(of: " ", with: "") == "Gimme some content" || currentCategory == ""){
            let alert = UIAlertController(title: "Alert", message: "Please complete all the informations", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let key: String?
            if let numberOfLastPost = numberOfLastPost{
                key = String(Int(numberOfLastPost)! + 1)
            }else {
                key = "1"
            }
            let post = ["Title": currentTitle, "Category": currentCategory, "Content": currentContent]
            //let postRef = ref?.push()
            ref?.child("PostsData").child(key!).setValue(post)
            ref?.child("PostsData").child(key!).child("Color").setValue(currentColorComponents)
            ref?.child("Likes").child(currentCategory).child(key!).setValue(0)
            
            ////user default
            let defaults = UserDefaults.standard
            if let userPostList = defaults.object(forKey: "userPostList") as? [String] {
                var existed = false
                for post in userPostList{
                    if(post == key!){
                        existed = true
                    }
                }
                if !existed {
                    var newUserPostList = userPostList
                    newUserPostList.append(key!)
                    defaults.set(newUserPostList, forKey: "userPostList")
                }
            }else{
                let userPostList = [key!]
                defaults.set(userPostList, forKey: "userPostList")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNewPost"), object: nil)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func back(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
        print("canceled")
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

extension AddingPostPopUpVC: MaterialColorPickerDelegate {
    func didSelectColorAtIndex(_ materialColorPickerView: MaterialColorPicker, index: Int, color: UIColor) {
        endEditingButton.backgroundColor = color
        card.backgroundColor = color
        changeColorButton.backgroundColor = color
        currentColor = color
        let red = color.components.red
        let blue = color.components.blue
        let green = color.components.green
        let alpha = color.components.alpha
        currentColorComponents = ["red" : Float(red),"blue" : Float(blue), "green": Float(green), "alpha" : Float(alpha)]
    }
    
    func sizeForCellAtIndex(MaterialColorPickerView: MaterialColorPicker, index: Int)->CGSize{
        return CGSize(width: view.frame.width/10,height: view.frame.width/10)
    }
    
    @objc func donePick() {
        if currentColor != UIColor.white {
            UIView.animate(withDuration: 0.5, animations: {
                self.endEditingButton.alpha = 0
                self.colorPicker.alpha = 0
            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.endEditingButton.removeFromSuperview()
                self.colorPicker.removeFromSuperview()
            })
        }else{
            return
        }
    }
    
    func picker(){
        endEditingButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        endEditingButton.setTitle("", for: .normal)
        endEditingButton.setTitleColor(UIColor.black, for: .normal)
        endEditingButton.backgroundColor = currentColor
        endEditingButton.layer.cornerRadius = 2
        endEditingButton.alpha = 0
        view.addSubview(endEditingButton)
        endEditingButton.addTarget(self, action: #selector(donePick), for: .touchUpInside)
        
        /*
         colorView = UIView(frame: CGRect(x: view.frame.width*0.1, y: view.frame.height*0.2, width: view.frame.width/2, height: view.frame.width/2))
         colorView.backgroundColor = UIColor.cyan
         view.addSubview(colorView)
         */
        let pickerSize = CGSize(width: view.frame.height/*view.frame.width/2*//*view.bounds.width*0.4*/, height: view.frame.width/4/*view.bounds.width*0.4*/)
        let pickerOrigin = CGPoint(x: 0-view.frame.height/2+view.frame.width/2/*view.frame.width/4*//*view.bounds.midX - pickerSize.width/2*/, y: view.frame.height/2-view.frame.width/8/*view.frame.width/2-view.frame.width/4*//*view.bounds.midY - pickerSize.height/2*/)
        
        /* Create Color Picker */
        //colorPicker.shuffleColors = true
        //
        colorPicker = MaterialColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colorPicker.cellSpacing = 10
        colorPicker.selectionColor = UIColor.white
        endEditingButton.addSubview(colorPicker)
        colorPicker.backgroundColor = UIColor.clear
        colorPicker.shuffleColors = true
        colorPicker.transform = CGAffineTransform(rotationAngle: 3.14159265/2)
        colorPicker.alpha = 0
        colorPicker.delegate = self
        
        /*
         /* Customize the view (optional) */
         colorPicker.padding = 10
         colorPicker.stroke = 3 //stroke of the rainbow circle
         colorPicker.currentAngle = Float.pi
         colorPicker.shadeSlider.changeColorHue(to: UIColor.black)
         /* Customize for grayscale (optional) */
         colorPicker.supportsShadesOfGray = true // false by default
         //colorPicker.colorToggleButton.grayColorGradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor] // You can also override gradient colors
         
         colorPicker.hexLabel.textColor = UIColor.white
         /* Don't want an element like the shade slider? Just hide it: */
         //colorPicker.shadeSlider.hidden = true
         colorPicker.addTarget(self, action: #selector(setBackground(picker:)), for: .editingDidEnd)
         */
    }
}

extension AddingPostPopUpVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //changeColorButton.setTitle("\(textField.text!.characters.count)", for: .normal)
        return (textField.text?.characters.count)! + (string.characters.count - range.length) <= 27
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        currentTitle = textField.text!
    }
    
    func addTitle(){
        titleField = UITextField(frame: CGRect(x: card.frame.width*0.05, y: card.frame.height*0.1, width: card.frame.width*0.9, height: card.frame.height*0.05))
        titleField.placeholder = "Insert your title"
        titleField.textColor = UIColor.white
        //titleField.font =
        //titleView.placeholder.font = UIFont.systemFont(ofSize: (view.frame.width/8)/2, weight: UIFont.Weight.semibold)
        card.addSubview(titleField)
        titleField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        titleField.delegate = self
        
        titleField.font =  UIFont.systemFont(ofSize: (view.frame.width/8)/2.5, weight: UIFont.Weight.regular)
    }
}

extension AddingPostPopUpVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categoryTitles[indexPath.row].name
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        //cell.layer.cornerRadius = 10;
        //cell.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        categoryButton.setTitle(cell?.textLabel?.text, for: .normal)
        self.categoryView.isHidden = true
        currentCategory = (cell?.textLabel?.text)!
        if let button = categoryEndEditingButton{
            button.removeFromSuperview()
        }
    }
    
    @objc func drop(_ sender: UIButton)
    {
        if(self.categoryView.isHidden == true){
            categoryEndEditingButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            categoryEndEditingButton.setTitle("", for: .normal)
            categoryEndEditingButton.backgroundColor = UIColor.clear
            view.insertSubview(categoryEndEditingButton, belowSubview: categoryButton)
            categoryEndEditingButton.addTarget(self, action: #selector(CategoryCancel(_:)), for: .touchUpInside)
        }else{
            if let button = categoryEndEditingButton{
                button.removeFromSuperview()
            }
        }
        self.categoryView.isHidden = !self.categoryView.isHidden
    }
    
    @objc func CategoryCancel(_ sender: UIButton){
        categoryEndEditingButton.removeFromSuperview()
        self.categoryView.isHidden = !self.categoryView.isHidden
    }
    
    func addCategory(){
        categoryButton = UIButton(frame: CGRect(x: view.frame.width*0.95-card.frame.width/2-10, y:view.frame.height*0.15 + 10 ,width: card.frame.width/2 , height: card.frame.width/16))
        categoryButton.backgroundColor = UIColor.clear
        categoryButton.setTitle("Choose a category", for: .normal)
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: (view.frame.width/8)/4, weight: UIFont.Weight.regular)
        categoryView = UITableView(frame: CGRect(x: view.frame.width*0.95-card.frame.width/2-10, y: view.frame.height*0.15 + 10 + card.frame.width/16, width: card.frame.width/2, height: card.frame.width))
        categoryButton.contentHorizontalAlignment = .right
        categoryButton.contentVerticalAlignment = .top
        categoryView.layer.cornerRadius = 20
        //categoryView.rowHeight = 20
        view.addSubview(categoryButton)
        view.addSubview(categoryView)
        categoryView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        categoryButton.addTarget(self, action: #selector(drop(_:)), for: .touchUpInside)
        categoryView.delegate = self;
        categoryView.dataSource = self;
        //categoryView.backgroundColor = UIColor.clear
    }
}


extension AddingPostPopUpVC: UITextViewDelegate{
    
    func addContentView(){
        contentView = UITextView(frame: CGRect(x: card.frame.width*0.05, y: card.frame.height*0.2, width: card.frame.width*0.9, height: card.frame.height*0.75))
        contentView.text = "Gimme some content"
        contentView.backgroundColor = UIColor.clear
        contentView.textColor = UIColor.white
        //contentView.text = UIFont.systemFont(ofSize: (view.frame.width/8)/4, weight: UIFont.Weight.regular)
        card.addSubview(contentView)
        contentView.font =  UIFont.systemFont(ofSize: view.frame.width/18, weight: UIFont.Weight.regular)
        contentView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Gimme some content"  || textView.text.replacingOccurrences(of:  " ", with: "") == "" {
            textView.text = ""
            textView.textColor = UIColor.white
        }
        //print("started")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.characters.count == 0){
            textView.textColor = UIColor.white
            textView.text = "Gimme some content"
        }
        //print(currentContent)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        currentContent = textView.text!
    }
    
    @objc func updateTextView (notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            contentView.contentInset = UIEdgeInsets.zero
        }else{
            contentView.contentInset = UIEdgeInsetsMake(0, 0, keyboardEndFrame.height-(view.frame.height*0.15), 0)
            contentView.scrollIndicatorInsets = contentView.contentInset
        }
        
        contentView.scrollRangeToVisible(contentView.selectedRange)
    }
}
