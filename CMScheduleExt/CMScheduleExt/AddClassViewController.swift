//
//  AddClassViewController.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 11/4/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: Data
    var data = ["CPSC 313","CPSC 331","CPSC 575", "ECON 201", "ARKY 201", "ARKY 417", "INTR 501", "BIST 600", "CHIN 317", "MUSI 211", "CHEM 301"]
    var classSections: [String: Array<String>] = [:]
    
    // MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    var selected: IndexPath = IndexPath.init()
    var selectedScroller: ASHorizontalScrollView? = nil
    var filtered:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK: Loading Class Data
        for name in data {
            classSections[name] = ["LEC 1: MWF 12:00 - 12:50", "Lecture 2", "Lecture 3", "Lab 1", "Lab 2"]
        }
        
        // Setup Delegates
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive || !selected.isEmpty) {
            return filtered.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{

        if((!selected.isEmpty) && indexPath.row == selected.row) {
            return 150
        } else {
        return 40
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ClassTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        if(searchActive){
            cell.courseName.text = filtered[indexPath.row]
        }
    return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ClassTableViewCell
        let cellName = cell.courseName.text
        
        
        if (selectedScroller != nil) {
            selectedScroller?.removeFromSuperview()
        }
        
        let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        //for all other screen sizes that doesn't set here, it would use defaultMarginSettings instead
        horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 10, miniAppearWidthOfLastItem: 20)
        
        horizontalScrollView.uniformItemSize = CGSize(width: 80, height: 50)
        //this must be called after changing any size or margin property of this class to get acurrate margin
        horizontalScrollView.setItemsMarginOnce()
        
        for section in classSections[cellName!]!{
            let button = UIButton(frame: CGRect.zero)
            button.setTitle(section, for: .normal)
            let backColor = UIColor(red: 182/255, green: 209/255, blue: 146/255, alpha: 1)
            button.backgroundColor = backColor
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.cornerRadius = 5
            button.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Thin" , size: 20)
            button.addTarget(self, action: #selector(sectionSelected), for: .touchUpInside)
            
            
            horizontalScrollView.addItem(button)
        }
        
        
        cell.contentView.addSubview(horizontalScrollView)
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
        cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 40))
        cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60))
        cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
        
        tableView.reloadData()
        
        selectedScroller = horizontalScrollView
        
        selected = indexPath
        searchBar.resignFirstResponder()
        
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    //    MARK: Actions

    @IBAction func undweaadosfj(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    func showAlert() {
        let alert = UIAlertController(title: "Added Succesfully", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    @objc func sectionSelected(sender: UIButton!) {
        showAlert()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //    MARK: Searchbar
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false;
        self.searchBar.endEditing(true)
        tableView.isHidden = true
        searchBar.setShowsCancelButton(false, animated: true)
        filtered = []
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            
            
            
            filtered = data.filter({ (text) -> Bool in
                let tmp: NSString = text as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
                
            })
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
        }
        else {
            filtered = []
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        tableView.isHidden = false
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    

}




// Attempt at using Action Sheet for selcting classes

//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    searchBar.resignFirstResponder()
//
//    //optional, to get from any UIButton for example
//
//    let indexPath = tableView.indexPathForSelectedRow
//    let cell = tableView.cellForRow(at: indexPath!)
//    let cellText = cell!.textLabel!.text ?? "Default Class"
//
//
//
//    let optionMenu = UIAlertController(title: nil, message: cellText, preferredStyle: .actionSheet)
//
//
//
//    let action = UIAlertAction(title: "Save", style: .default){ _ in
//        print("We can run a block of code." )
//    }
//
//    let saveAction = UIAlertAction(title: "Save", style: .default)
//
//    // 3
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//    // 4
//    optionMenu.addAction(saveAction)
//    optionMenu.addAction(cancelAction)
//    optionMenu.addAction(action)
//
//    // 5
//    self.present(optionMenu, animated: true, completion: nil)
//}




//
//        let optionMenu = UIAlertController(title: nil, message: cellText, preferredStyle: .actionSheet)
//
//
//        for sectionName in classSections[cellText]! {
//            optionMenu.addAction(UIAlertAction(title: sectionName, style: .default){ _ in
//                        self.showAlert()
//                        print(cellText)
//                        print(sectionName)
//
//
//                        })
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        // 4
//
//        optionMenu.addAction(cancelAction)
//
//
////        let action = UIAlertAction(title: "Save", style: .default){ _ in
////            print("We can run a block of code." )
////        }
////        optionMenu.addAction(action)
//
//        // 5
//        self.present(optionMenu, animated: true, completion: nil)
