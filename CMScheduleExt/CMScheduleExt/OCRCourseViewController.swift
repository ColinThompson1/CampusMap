//
//  OCRCourseViewController.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 12/12/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class OCRCourseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var OCRData = [Class?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isEditing = true
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    

    
    func loadData(courseData: [Class?]) {
        OCRData = courseData
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle : UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.OCRData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OCRData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OCRCell") as? OCRTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        cell.courseName.text = "\(OCRData[indexPath.row]?.name ?? "Class not found")"
        cell.courseInfo.text = "\(OCRData[indexPath.row]?.type ?? "")"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    func showSuccessAlert(classesAdded: Int) {
        let alert = UIAlertController(title: "Added \(classesAdded) Classes Successfully", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func showFailAlert() {
        let alert = UIAlertController(title: "No Times for this Section", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    @IBAction func addAllAction(_ sender: Any) {
        var classesAdded = 0
        for index in OCRData {
            if index?.name != nil {
                let aCourse = Class(name: index!.name, type: index!.type, semester: index!.semester, days: index!.days, room: index!.room)
                ScheduleViewController().addCourse(aCourse!)
                classesAdded += 1
            }
            
        }
        
        showSuccessAlert(classesAdded: classesAdded)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {self.dismiss(animated: true, completion: nil)})
        
        
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        
        // create the alert
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to cancel? No classes will be added.", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
