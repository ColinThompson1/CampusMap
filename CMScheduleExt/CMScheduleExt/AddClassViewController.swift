//
//  AddClassViewController.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 11/4/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    

    
    
    var searchActive : Bool = false
    var data = ["CPSC 313","CPSC 331","CPSC 575", "ECON 201", "ARKY 201", "ARKY 417", "INTR 501", "BIST 600", "CHIN 317", "MUSI 211", "CHEM 301"]
    var classSections: [String: Array<String>] = [:]

    
    var filtered:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for name in data {
            classSections[name] = ["LEC 1: MWF 12:00 - 12:50", "Lecture 2", "Lecture 3", "Lab 1", "Lab 2"]
        }
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        tableView.isHidden = false
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
//        self.searchBar.endEditing(true)
//        print("searchBarTextDidEndEditing")

    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        }        
        return cell;
    }

    @IBAction func undweaadosfj(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    func showAlert() {
        let alert = UIAlertController(title: "Added Succesfully", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBar.resignFirstResponder()
        
        //optional, to get from any UIButton for example
        
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)
        let cellText = cell!.textLabel!.text ?? "Default Class"
        
        
        
        let optionMenu = UIAlertController(title: nil, message: cellText, preferredStyle: .actionSheet)
        
       
        for sectionName in classSections[cellText]! {
            optionMenu.addAction(UIAlertAction(title: sectionName, style: .default){ _ in
                        self.showAlert()
                        print(cellText)
                        print(sectionName)
                

                        })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4

        optionMenu.addAction(cancelAction)
        
        
//        let action = UIAlertAction(title: "Save", style: .default){ _ in
//            print("We can run a block of code." )
//        }
//        optionMenu.addAction(action)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}



//
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
