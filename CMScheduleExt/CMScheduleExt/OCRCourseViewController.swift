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
        print(OCRData)
        
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func loadData(courseData: [Class?]) {
        OCRData = courseData
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
