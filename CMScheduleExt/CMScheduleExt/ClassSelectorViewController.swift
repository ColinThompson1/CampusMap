//
//  AddClassViewController.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 11/4/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class ClassSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    

    
    
    // MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var data: [String] = []
    var classData: [String : Course] = [:]
    var classSections: [String: Array<String>] = [:]
    
    var searchActive : Bool = false
    var selected: IndexPath = IndexPath.init()
    var selectedScroller: ASHorizontalScrollView? = nil
    var selectedClass = ""
    var filtered:[String] = []
    var spinner: UIView? = nil
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = CourseDataSource.shared.getCourses(semesterID: 2191).done { (courses: [String : Course]) in
            self.data = courses.keys.sorted()
            self.classData = courses
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
    
    
    
    //MARK: - TableView Functions
    
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
            return 110
        } else {
        return 40
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ClassTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        if(searchActive || !selected.isEmpty){
            cell.courseName.text = filtered[indexPath.row]
        }
    return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ClassTableViewCell
        let cellName = cell.courseName.text
        selectedClass = cell.courseName.text!
        
        if (selectedScroller != nil) {
            selectedScroller?.removeFromSuperview()
        }
        
        let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        //for all other screen sizes that doesn't set here, it would use defaultMarginSettings instead
        horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 10, miniAppearWidthOfLastItem: 20)
        
        horizontalScrollView.uniformItemSize = CGSize(width: 80, height: 50)
        //this must be called after changing any size or margin property of this class to get acurrate margin
        horizontalScrollView.setItemsMarginOnce()
        
        
        guard let currentClassSections: [String : Periodic] = classData[cellName!]?.periodics else {
            print("Cannot get periodics of course \(String(describing: cellName))")
            return
        }
        let currentClassSectionKeys = currentClassSections.keys.sorted()
        
  
        for courseCode in currentClassSectionKeys {
            let button = ClassButton(frame: CGRect.zero)
            button.setTitle("\(courseCode)", for: .normal)
            
            // pass this to the button press handler
            button.type = currentClassSections[courseCode]!.type
            button.section = currentClassSections[courseCode]!.name
            button.periods = currentClassSections[courseCode]!.timePeriods
            button.room = currentClassSections[courseCode]!.room
            
            let backColor = UIColor(red: 182/255, green: 209/255, blue: 146/255, alpha: 1)
            button.backgroundColor = backColor
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.cornerRadius = 5
            button.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Thin" , size: 17)
            button.sizeToFit()
            button.addTarget(self, action: #selector(sectionSelected), for: .touchUpInside)
            
            
            horizontalScrollView.addItem(button)
        }
        
        cell.contentView.addSubview(horizontalScrollView)
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
        cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 40))
        cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60))
        cell.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
        
        selectedScroller = horizontalScrollView
        
        selected = indexPath
        searchBar.resignFirstResponder()
        
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    //    MARK: Actions

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Added Successfully", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func showFailAlert() {
        let alert = UIAlertController(title: "No Times for this Section", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    @objc func sectionSelected(sender: ClassButton!) {
        
        // get all the days and times of the class
        var days = [String:String]()
        var semester = [String: String]()
        
        let timePeriods = sender.periods
        for period in timePeriods {
            days["\(period.day.rawValue)"] = "\(period.time)"
            semester["\(period.day.rawValue)"] = "\(period.date)"
        }
        
        if timePeriods.isEmpty {
            showFailAlert()
        }
        else {
            let aCourse = Class(name: selectedClass, type: sender.currentTitle!, semester: semester, days: days, room: sender.room)
            print(sender.room)
            ScheduleViewController().addCourse(aCourse!)
            showSuccessAlert()
        }
    }
    
    
    //    MARK: Image Picker
    
    @IBAction func ImportPhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
  
        self.present(imagePicker, animated: true, completion: nil)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        _ = RestService.shared.postPNG(path: "", params: [:], image: selectedImage, responseType: OCRCourses.self).then { (ocrCourses: [String : OCRCourse]) in
            return CourseDataSource.shared.convertAll(cs: ocrCourses, semesterID: 2191)
            }.done { (courses: [Class?]) in
                
                self.removeSpinner(spinner: self.spinner!)
                let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddOCRClass") as! OCRCourseViewController
                addVC.loadData(courseData: courses)
                self.present(addVC, animated: true, completion: nil)

        }
        spinner = displaySpinner(onView: self.view)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //    MARK: Searchbar
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false;
        self.searchBar.endEditing(true)
        tableView.isHidden = true
        searchBar.setShowsCancelButton(false, animated: true)
        filtered = []
        if (selectedScroller != nil) {
            selectedScroller?.removeFromSuperview()
            selected.row = -1
        }
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
        
        if (selectedScroller != nil) {
            selectedScroller?.removeFromSuperview()
            selected.row = -1
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
    
    // MARK: Spinner
    func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    

}
