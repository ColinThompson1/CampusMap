//
//  ScheduleViewController.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 11/6/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

var courses = [Class]()

class ScheduleViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var classes: UITableView!
    private var data: [String] = []
    var mon = [Class]()
    var tue = [Class]()
    var wed = [Class]()
    var thu = [Class]()
    var fri = [Class]()
    
    var count = 0
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Monday"
        }else if section == 1{
            return "Tuesday"
        }else if section == 2{
            return "Wednesday"
        }else if section == 3{
            return "Thursday"
        }else if section == 4{
            return "Friday"
        }else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        count = 0
        if section == 0{
            for course in courses{
                if course.days.contains("Monday"){
                    count += 1
                    mon.append(course)
                }
            }
            
            return count
        }else if section == 1{
            for course in courses{
                if course.days.contains("Tuesday"){
                    count += 1
                    tue.append(course)
                }
            }
            
            return count
        }else if section == 2{
            for course in courses{
                if course.days.contains("Wednesday"){
                    count += 1
                    wed.append(course)
                }
            }
            
            return count
        }else if section == 3{
            for course in courses{
                if course.days.contains("Thursday"){
                    count += 1
                    thu.append(course)
                }
            }
            
            return count
        }else if section == 4{
            for course in courses{
                if course.days.contains("Friday"){
                    count += 1
                    fri.append(course)
                }
            }
            
            return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classesRow", for: indexPath) //1.
        
        var text :String = ""
        
        if indexPath.section == 0{
            text = mon[indexPath.row].name
        }else if indexPath.section == 1{
            text = tue[indexPath.row].name
        }else if indexPath.section == 2{
            text = wed[indexPath.row].name
        }else if indexPath.section == 3{
            text = thu[indexPath.row].name
        }else if indexPath.section == 4{
            text = fri[indexPath.row].name
        }
        
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleCourses()
        classes.dataSource = self
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ScheduleViewController.panGesture))
        view.addGestureRecognizer(gesture)        // Do any additional setup after loading the view.
    }
    
    private func loadSampleCourses() {
        
        let course1 = Class(name: "CPSC 501", section: 1, startTime: "09:00", endTime: "09:50", semester: "Fall", days: ["Monday", "Wednesday", "Friday"])
        let course2 = Class(name: "CPSC 575", section: 1, startTime: "10:00", endTime: "10:50", semester: "Fall", days: ["Monday", "Wednesday", "Friday"])
        
        courses.append(course1!)
        courses.append(course2!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 500
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
}

