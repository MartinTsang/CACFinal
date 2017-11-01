//
//  ExploreTableViewController.swift
//  CACproject
//
//  Created by Timothy Park on 10/18/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit
import SimpleAlert

class ExploreTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    
    let categorytitles = CategoryTitles()
    var colorArray = [UIColor]()
    var categoryTitles = [Categories]()
    
    @IBOutlet weak var newCategoriesTableView: UITableView!
    @IBOutlet weak var footerView: footerViewClass!

    let searchController = UISearchController(searchResultsController: nil)
    
    var userDefaultsCategoryShit2: [String] = []
    let defaults2 = UserDefaults.standard
    
    var catgories = [Categories]()
    var filteredCategories = [Categories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorArray = categorytitles.colorArray
        categoryTitles = categorytitles.categoryTitles
        //defaults2.set(userDefaultsCategoryShit2, forKey: "iLoveYou2")
        
        newCategoriesTableView.dataSource = self
        newCategoriesTableView.delegate = self
        
        self.navigationController?.title = "Explore"
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        newCategoriesTableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.newCategoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Popular"]
        searchController.searchBar.delegate = self
        
        // Setup the search footer
        newCategoriesTableView.tableFooterView = footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            cell.accessoryView?.frame.size = CGSize(width: 50, height: 50)
            userDefaultsCategoryShit2.append(categoryTitles[indexPath.row].name)
            print("\(categoryTitles[indexPath.row].name) has been added to your categories")
            
            //
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 12)
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self.newCategoriesTableView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self.newCategoriesTableView, attribute: .centerY, multiplier: 1.85, constant: 0.0))
            
            //            label.center.x = view.center.x
            //            label.center.y = view.center.y - 100
            label.text = "\(categoryTitles[indexPath.row].name) has been added"
            
            
            ////
            let defaults = UserDefaults.standard
            if let userCategoryList = defaults.object(forKey: "userCategoryList") as? [String]{
                var existed = false
                for category in userCategoryList{
                    if categoryTitles[indexPath.row].name == category{
                        existed = true
                    }
                }
                if(!existed){
                    var newUserCategoryList = userCategoryList
                    newUserCategoryList.append(categoryTitles[indexPath.row].name)
                    defaults.set(newUserCategoryList, forKey: "userCategoryList")
                }
            }else{
                let newUserCategoryList = [categoryTitles[indexPath.row].name]
                defaults.set(newUserCategoryList, forKey: "userCategoryList")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userCategoryChanged"), object: nil)
            print(defaults.object(forKey: "userCategoryList")!)
            label.fadeIn()
            label.fadeOut()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            if userDefaultsCategoryShit2.contains(categoryTitles[indexPath.row].name) {
                userDefaultsCategoryShit2.remove(e: categoryTitles[indexPath.row].name)
                print("\(categoryTitles[indexPath.row].name) has been removed to your categories")
                
                let label2: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
                view.addSubview(label2)
                label2.translatesAutoresizingMaskIntoConstraints = false
                label2.font = UIFont.boldSystemFont(ofSize: 12)
                view.addConstraint(NSLayoutConstraint(item: label2, attribute: .centerX, relatedBy: .equal, toItem: self.newCategoriesTableView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                view.addConstraint(NSLayoutConstraint(item: label2, attribute: .centerY, relatedBy: .equal, toItem: self.newCategoriesTableView, attribute: .centerY, multiplier: 1.85, constant: 0.0))
                //            label.center.x = view.center.x
                //            label.center.y = view.center.y - 100
                label2.text = "\(categoryTitles[indexPath.row].name) has been removed"
                
                ///
                let defaults = UserDefaults.standard
                if let userCategoryList = defaults.object(forKey: "userCategoryList") as? [String] {
                    for category in userCategoryList{
                        if category == categoryTitles[indexPath.row].name{
                            var newUserCategoryList = userCategoryList
                            newUserCategoryList.remove(e: categoryTitles[indexPath.row].name)
                            defaults.set(newUserCategoryList, forKey: "userCategoryList")
                        }
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userCategoryChanged"), object: nil)
                print(defaults.object(forKey: "userCategoryList")!)
                label2.fadeIn()
                label2.fadeOut()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if splitViewController!.isCollapsed {
//            if let selectionIndexPath = newCategoriesTableView.indexPathForSelectedRow {
//                newCategoriesTableView.deselectRow(at: selectionIndexPath, animated: animated)
//            }
//        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            footerView.setIsFilteringToShow(filteredItemCount: filteredCategories.count, of: categoryTitles.count)
            return filteredCategories.count
        }
        
        footerView.setNotFiltering()
        return categoryTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newCategoriesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.backgroundColor = colorArray[indexPath.row]
        let entry: Categories
        if isFiltering() {
            entry = filteredCategories[indexPath.row]
        } else {
            entry = categoryTitles[indexPath.row]
        }
        
        cell.textLabel?.text = entry.name
        cell.detailTextLabel?.text = entry.description
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCategories = categoryTitles.filter({( candy : Categories) -> Bool in
            let doesCategoryMatch = (scope == "All") || (candy.description == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
        })
        newCategoriesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    @IBAction func showPopup(_ sender: Any) {
        
        let alert = AlertController(title: "Suggest a Category", message: "we're open to anything 😌", style: .alert)
        alert.addTextFieldWithConfigurationHandler() { textField in
            textField?.frame.size.height = 33
            textField?.backgroundColor = nil
            textField?.layer.borderColor = nil
            textField?.layer.borderWidth = 0
        }
        alert.configContentView = { [weak self] view in
            if let view = view as? AlertContentView {
                view.titleLabel.textColor = UIColor.black
                view.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
                view.messageLabel.textColor = UIColor.black
                view.messageLabel.font = UIFont.boldSystemFont(ofSize: 13)
                view.textBackgroundView.layer.cornerRadius = 8.0
                view.textBackgroundView.clipsToBounds = true
            }
        }
        alert.addAction(AlertAction(title: "nvm 🙊", style: .cancel))
        alert.addAction(AlertAction(title: "Done!", style: .ok))
        present(alert, animated: true, completion: nil)
    }
}

extension ExploreTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension ExploreTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

class customCell: UITableViewCell {
    
    //@IBOutlet weak var view: UIView!
    var followButton = UIButton()
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //makeTheButton()
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 2))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.bounds = CGRect(x: self.bounds.origin.x + 20, y: self.bounds.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
        //label.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        label.text = "Hi bye hi bye hi bye"
        contentView.addSubview(label)
        
    }

    override func layoutSubviews() {
        // Set the width of the cell
        super.layoutSubviews()
        contentView.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
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
    
}

extension UIColor {
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
    
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

class CategoryTitles{
    let categoryTitles: [Categories] = [Categories(name: "Asian Studies 🍱", description: "Popular"),
                                        Categories(name: "Mexico 🇲🇽", description: "all about politics"),
                                        Categories(name: "Machine Learning 👁", description: "Popular"),
                                        Categories(name: "LGBT 🌈", description: "Popular"),
                                        Categories(name: "Architecture 🏔", description: "venture capital and startup culture"),
                                        Categories(name: "Astronomy 👨🏻‍🚀", description: "Popular"),
                                        Categories(name: "Biological Sciences 📚", description: "science tech engineering math"),
                                        Categories(name: "Civil Studies 🗣", description: "current state of networking"),
                                        Categories(name: "Economics 👨🏻‍🎓", description: "the future?"),
                                        Categories(name: "English 📓", description: "Popular"),
                                        Categories(name: "Human Development 👩🏻‍💻", description: ""),
                                        Categories(name: "Italian 📲", description: "All about politics"),
                                        Categories(name: "Linguistics 📞", description: "Popular"),
                                        
                                        
                                        Categories(name: "Nutrition 👩🏻‍⚕️", description: "Popular"),
                                        Categories(name: "Operations 👨🏻‍⚖️", description: "all about politics"),
                                        Categories(name: "Philosophy 🌍", description: "the world as we know it"),
                                        Categories(name: "Physics 🛳", description: "Popular"),
                                        Categories(name: "Plant Science 👩🏼‍🔧", description: "engineering from all angles"),
                                        Categories(name: "Statistics 📚", description: "science tech engineering math"),
                                        Categories(name: "Animals 🙉", description: "current state of networking"),
                                        Categories(name: "Urban 👨🏻‍🎓", description: "the future?"),
                                        Categories(name: "Regional 🛩", description: "gadgets, reviews, and more"),
                                        Categories(name: "Government 👩🏻‍💻", description: ""),
                                        Categories(name: "Awards 🎖", description: "Popular"),
                                        Categories(name: "Research 🔢", description: "Popular"),
                                        
                                        Categories(name: "Biotechnology 👩🏼‍🔬", description: "Popular"),
                                        Categories(name: "Policy 👨🏻‍⚖️", description: "all about politics"),
                                        Categories(name: "Humanities 🌍", description: "the world as we know it"),
                                        Categories(name: "Startups 🤑", description: "venture capital and startup culture"),
                                        Categories(name: "Engineering 👩🏼‍🔧", description: "Popular"),
                                        Categories(name: "STEM 📚", description: "Popular"),
                                        Categories(name: "Social Media 🙉", description: "Popular"),
                                        Categories(name: "Education 👨🏻‍🎓", description: "Popular"),
                                        Categories(name: "Tech 👩🏿‍💻", description: "gadgets, reviews, and more"),
                                        Categories(name: "Web 👩🏻‍💻", description: ""),
                                        Categories(name: "Applications 📲", description: "All about politics"),
                                        Categories(name: "Sports 🏃🏻‍♀️", description: "All about politics"),
                                        
                                        
                                        Categories(name: "iOS Development 📱", description: "Popular"),
                                        Categories(name: "Music 🎵", description: "all about politics"),
                                        Categories(name: "Culture 🌍", description: "the world as we know it"),
                                        Categories(name: "Hot Button Topics ⛳", description: "venture capital and startup culture"),
                                        Categories(name: "Friends 🎎", description: "engineering from all angles"),
                                        Categories(name: "Communications 📚", description: "Popular"),
                                        Categories(name: "Digital Studies 🙉", description: "current state of networking"),
                                        Categories(name: "Homes 👨🏻‍🎓", description: "the future?"),
                                        Categories(name: "Finance 👩🏿‍💻", description: "👁"),
                                        Categories(name: "Coding 👩🏻‍💻", description: ""),
                                        Categories(name: "Ethical Hacking 📲", description: "All about politics"),
                                        Categories(name: "Healthcare 🏃🏻‍♀️", description: "All about politics"),
                                        
                                        Categories(name: "Fitness 🎳", description: "Popular"),
                                        Categories(name: "Fun Stuff 🏀", description: "all about politics"),
                                        Categories(name: "Enology ☄", description: "the world as we know it"),
                                        Categories(name: "Earth 🌍", description: "Popular"),
                                        Categories(name: "Sociology 👩🏼‍🔧", description: "engineering from all angles"),
                                        Categories(name: "STEM 📚", description: "science tech engineering math"),
                                        Categories(name: "Weather ☔", description: "the future?")]
    
    let colorArray: [UIColor] = [UIColor(red:0.85, green:0.30, blue:0.30, alpha:1.0),
                                 UIColor(red:0.85, green:0.38, blue:0.30, alpha:1.0),
                                 UIColor(red:0.85, green:0.46, blue:0.30, alpha:1.0),
                                 UIColor(red:0.85, green:0.54, blue:0.30, alpha:1.0),
                                 UIColor(red:0.85, green:0.62, blue:0.30, alpha:1.0),
                                 UIColor(red:0.85, green:0.70, blue:0.30, alpha:1.0),
                                 UIColor(red:0.85, green:0.78, blue:0.30, alpha:1.0),
                                 UIColor(red:0.85, green:0.85, blue:0.30, alpha:1.0),
                                 
                                 UIColor(red:0.80, green:0.85, blue:0.30, alpha:1.0),
                                 UIColor(red:0.72, green:0.85, blue:0.30, alpha:1.0),
                                 UIColor(red:0.64, green:0.85, blue:0.30, alpha:1.0),
                                 UIColor(red:0.54, green:0.85, blue:0.30, alpha:1.0),
                                 UIColor(red:0.48, green:0.85, blue:0.30, alpha:1.0),
                                 UIColor(red:0.40, green:0.85, blue:0.30, alpha:1.0),
                                 UIColor(red:0.32, green:0.85, blue:0.30, alpha:1.0),
                                 UIColor(red:0.30, green:0.85, blue:0.30, alpha:1.0),
                                 
                                 UIColor(red:0.30, green:0.85, blue:0.35, alpha:1.0),
                                 UIColor(red:0.30, green:0.85, blue:0.46, alpha:1.0),
                                 UIColor(red:0.30, green:0.85, blue:0.58, alpha:1.0),
                                 UIColor(red:0.30, green:0.85, blue:0.64, alpha:1.0),
                                 UIColor(red:0.30, green:0.85, blue:0.70, alpha:1.0),
                                 UIColor(red:0.30, green:0.85, blue:0.74, alpha:1.0),
                                 UIColor(red:0.30, green:0.85, blue:0.82, alpha:1.0),
                                 UIColor(red:0.30, green:0.85, blue:0.85, alpha:1.0),
                                 
                                 UIColor(red:0.30, green:0.85, blue:0.85, alpha:1.0),
                                 UIColor(red:0.30, green:0.74, blue:0.85, alpha:1.0),
                                 UIColor(red:0.30, green:0.70, blue:0.85, alpha:1.0),
                                 UIColor(red:0.30, green:0.64, blue:0.85, alpha:1.0),
                                 UIColor(red:0.30, green:0.57, blue:0.85, alpha:1.0),
                                 UIColor(red:0.30, green:0.49, blue:0.85, alpha:1.0),
                                 UIColor(red:0.30, green:0.40, blue:0.85, alpha:1.0),
                                 UIColor(red:0.30, green:0.30, blue:0.85, alpha:1.0),
                                 
                                 UIColor(red:0.37, green:0.85, blue:0.85, alpha:1.0),
                                 UIColor(red:0.44, green:0.74, blue:0.85, alpha:1.0),
                                 UIColor(red:0.52, green:0.70, blue:0.85, alpha:1.0),
                                 UIColor(red:0.60, green:0.64, blue:0.85, alpha:1.0),
                                 UIColor(red:0.68, green:0.57, blue:0.85, alpha:1.0),
                                 UIColor(red:0.76, green:0.49, blue:0.85, alpha:1.0),
                                 UIColor(red:0.84, green:0.40, blue:0.85, alpha:1.0),
                                 UIColor(red:0.85, green:0.30, blue:0.85, alpha:1.0),
                                 
                                 UIColor(red:0.37, green:0.85, blue:0.85, alpha:1.0),
                                 UIColor(red:0.44, green:0.74, blue:0.85, alpha:1.0),
                                 UIColor(red:0.52, green:0.70, blue:0.85, alpha:1.0),
                                 UIColor(red:0.60, green:0.64, blue:0.85, alpha:1.0),
                                 UIColor(red:0.68, green:0.57, blue:0.85, alpha:1.0),
                                 UIColor(red:0.76, green:0.49, blue:0.85, alpha:1.0),
                                 UIColor(red:0.84, green:0.40, blue:0.85, alpha:1.0),
                                 UIColor(red:0.85, green:0.30, blue:0.85, alpha:1.0),
                                 
                                 UIColor(red:0.37, green:0.85, blue:0.85, alpha:1.0),
                                 UIColor(red:0.44, green:0.74, blue:0.73, alpha:1.0),
                                 UIColor(red:0.52, green:0.70, blue:0.65, alpha:1.0),
                                 UIColor(red:0.60, green:0.64, blue:0.59, alpha:1.0),
                                 UIColor(red:0.68, green:0.57, blue:0.50, alpha:1.0),
                                 UIColor(red:0.76, green:0.49, blue:0.43, alpha:1.0),
                                 UIColor(red:0.84, green:0.40, blue:0.35, alpha:1.0),
                                 UIColor(red:0.85, green:0.30, blue:0.30, alpha:1.0)]
    
    init(){
        
    }
}
