//
//  ViewController.swift
//  ScheduleBuilder
//
//  Created by Xian-Meng Low on 2018-11-01.
//  Copyright © 2018 Xian-Meng Low. All rights reserved.
//

import UIKit

var courses = [Class] ()

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var onTop = false

    @IBOutlet weak var classes: UITableView!
    private var data: [String] = []

    
    var mon = [Class]()
    var tue = [Class]()
    var wed = [Class]()
    var thu = [Class]()
    var fri = [Class]()

    var events:[Date:[Class]] = [:]
    
    var count = 0
    var currentSectionAmount = 4
    let cellBuffer: CGFloat = 2
    
    var fetchingMore = false
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        /*let picker = UIDatePicker()
         
         
         
         let todaysEvents:[Class] = [
         Class(name: "name", section: 1, startTime: "12:00", endTime: "13:00", semester: "A", days: ["Mon"])!,
         Class(name: "name", section: 1, startTime: "12:00", endTime: "13:00", semester: "A", days: ["Mon"])!,
         Class(name: "name", section: 1, startTime: "12:00", endTime: "13:00", semester: "A", days: ["Mon"])!
         ]
         
         events[Date()] = todaysEvents*/
        
        return currentSectionAmount + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section % 5 == 0{
            return "Monday"
        }else if section % 5 == 1{
            return "Tuesday"
        }else if section % 5 == 2{
            return "Wednesday"
        }else if section % 5 == 3{
            return "Thursday"
        }else if section % 5 == 4{
            return "Friday"
        }else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        count = 0
        if section % 5 == 0{
            return mon.count
        }else if section % 5 == 1{
            return tue.count
        }else if section % 5 == 2{
            return wed.count
        }else if section % 5 == 3{
            return thu.count
        }else if section % 5 == 4{
            return fri.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classesRow", for: indexPath) //1.
        
        var text :String = ""
        
        if indexPath.section % 5 == 0{
            text = mon[indexPath.row].name
        }else if indexPath.section % 5 == 1{
            text = tue[indexPath.row].name
        }else if indexPath.section % 5 == 2{
            text = wed[indexPath.row].name
        }else if indexPath.section % 5 == 3{
            text = thu[indexPath.row].name
        }else if indexPath.section % 5 == 4{
            text = fri[indexPath.row].name
        }
        
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleCourses()
        mon = courses.filter({$0.days.contains("Monday")})
        tue = courses.filter({$0.days.contains("Tuesday")})
        wed = courses.filter({$0.days.contains("Wednesday")})
        thu = courses.filter({$0.days.contains("Thursday")})
        fri = courses.filter({$0.days.contains("Friday")})
        classes.delegate = self
        classes.dataSource = self

        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        view.addGestureRecognizer(pan)        // Do any additional setup after loading the view.

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.tapGesture))
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - UIScreen.main.bounds.height/8
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }

    private func loadSampleCourses() {

        let course1 = Class(name: "CPSC 501", section: 1, startTime: "09:00", endTime: "09:50", semester: "Fall", days: ["Monday", "Wednesday", "Friday"])
        let course2 = Class(name: "CPSC 575", section: 1, startTime: "10:00", endTime: "10:50", semester: "Fall", days: ["Monday", "Wednesday", "Friday"])

        courses.append(course1!)
        courses.append(course2!)
    }

    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view).y

        let y = self.view.frame.minY

        // top
        if (y + translation < view.frame.height/6) {

            onTop = true

            UIView.animate(withDuration: 0.3) {
                self.view.frame = CGRect(x: 0, y: self.view.frame.height/6, width: self.view.frame.width, height: self.view.frame.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.view.layoutIfNeeded()
            }
        }
            // bottom
        else if (y + translation > view.frame.height - view.frame.height/8) {

            onTop = false

            UIView.animate(withDuration: 0.3) {
                self.view.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height/8, width: self.view.frame.width, height: self.view.frame.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.view.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.view.frame = CGRect(x: 0, y: y + translation, width: self.view.frame.width, height: self.view.frame.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
        }
    }

    @objc func tapGesture(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            let location = recognizer.location(in: self.view)

            if location.y < self.view.frame.minY && onTop {
                onTop = false
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height/8, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
            else if location.y < self.view.frame.minY && !onTop {
                onTop = true
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.height/6, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        }
    }
    
    func scrollViewDidScroll (_ scrollView: UIScrollView){
        let offsetY = scrollView.contentOffset.y
        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let buffer: CGFloat = self.cellBuffer * 90
        
        if offsetY > bottom - buffer{
            if !fetchingMore{
                classes.reloadData()
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch(){
        fetchingMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50 , execute: {
            self.fetchingMore = false
            
            self.currentSectionAmount += 3
        })
    }



}
