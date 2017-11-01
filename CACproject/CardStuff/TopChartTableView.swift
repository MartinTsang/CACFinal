//
//  ExploreTableViewController.swift
//  CACproject
//
//  Created by Timothy Park on 10/18/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit
import SimpleAlert

class TopChartTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let categorytitles = CategoryTitles()
    var categoryTitles = [Categories]()
    var colorArray = [UIColor]()
    
    @IBOutlet weak var newCategoriesTableView: UITableView!
    
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
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        newCategoriesTableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.newCategoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Check out others' ideas"
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            //cell.accessoryType = .checkmark
            cell.accessoryView?.frame.size = CGSize(width: 50, height: 50)
            print(categoryTitles[indexPath.row].name)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TopChartVC") as! TopChartVC
            vc.category = categoryTitles[indexPath.row].name
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
            
    }
        
    /*
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
        }*/
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
            return filteredCategories.count
        }
        
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
}

extension TopChartTableView: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension TopChartTableView: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
