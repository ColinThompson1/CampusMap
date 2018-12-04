//
//  ViewController.swift
//  ScheduleBuilder
//
//  Created by Xian-Meng Low on 2018-11-01.
//  Copyright © 2018 Xian-Meng Low. All rights reserved.
//

import UIKit

var courses = [Class] ()
var classData = CourseData().getData()

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var today: UIButton!
    
    var onTop = false

    @IBOutlet weak var classes: UITableView!
    private var data: [String] = []

    
    var mon = [Class]()
    var tue = [Class]()
    var wed = [Class]()
    var thu = [Class]()
    var fri = [Class]()
    var sat = [Class]()
    var sun = [Class]()

    var events:[Date:[Class]] = [:]
    
    var count = 0
    var currentSectionAmount = 4
    let cellBuffer: CGFloat = 2
   
    let date = Date()
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    var fetchingMore = false
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return currentSectionAmount + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return dateToString(getNextDay(date, section))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dateFormatter.dateFormat = "EEEE"
        print(dateFormatter.string(from: getNextDay(date, section)))
        if ((dateFormatter.string(from: getNextDay(date, section))) == "Monday"){
            events[getNextDay(date, section)] = mon
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Tuesday"){
            events[getNextDay(date, section)] = tue
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Wednesday"){
            events[getNextDay(date, section)] = wed
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Thursday"){
            events[getNextDay(date, section)] = thu
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Friday"){
            events[getNextDay(date, section)] = fri
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Saturday"){
            events[getNextDay(date, section)] = sat
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Sunday"){
            events[getNextDay(date, section)] = sun
        }
        let some : [Class] = events[getNextDay(date, section)]!
        return (some.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classesRow", for: indexPath) //1.
        
        var text :String = ""
        text = (events[getNextDay(date, indexPath.section)]![indexPath.row]).name
        
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
        
        view.bringSubviewToFront(today)
        today.setTitle("Today", for: .normal)
        today.isHidden = true

        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(ScheduleViewController.panGesture))
        view.addGestureRecognizer(pan)
        
        print(classData["ACCT 217"]!["periodics"][0]["time-periods"])
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - UIScreen.main.bounds.height/8
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        
        // Blur the background
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect.init(style: .light)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)

        bluredView.frame = self.view.bounds
        bluredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(bluredView, at: 0)
        
        
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        navigationBar.backgroundColor = UIColor.clear
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        
        // title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Schedule"
        
        // Create right button
        let rightButton = UIBarButtonItem(title: "Add Classes", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ScheduleViewController.addClass))
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
    }
    
    
    @objc func addClass(sender: UIBarButtonItem) {
        
        let addVC = storyboard!.instantiateViewController(withIdentifier :"AddClass") as! AddClassViewController
        self.present(addVC, animated: true)
        
        // reset the location of the card
        onTop = false
    }
    
    private func loadSampleCourses() {

        let course1 = Class(name: "CPSC 501", section: 1, startTime: "09:00", endTime: "09:50", semester: "Fall", days: ["Monday", "Wednesday", "Friday"])
        let course2 = Class(name: "CPSC 575", section: 1, startTime: "10:00", endTime: "10:50", semester: "Fall", days: ["Monday", "Wednesday", "Friday"])
        let course3 = Class(name: "CPSC 413", section: 1, startTime: "10:00", endTime: "10:50", semester: "Fall", days: ["Tuesday", "Thursday"])
        
        courses.append(course1!)
        courses.append(course2!)
        courses.append(course3!)
    }

    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: self.view).y

        // go to top
        if (!onTop && (velocity < -300)) {

            onTop = true
            
            UIView.animate(withDuration: 0.3) {
                self.view.frame = CGRect(x: 0, y: self.view.frame.height/6, width: self.view.frame.width, height: self.view.frame.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.view.layoutIfNeeded()
            }
        }
        // go to bottom
        else if (onTop && (velocity > 300)) {

            onTop = false

            UIView.animate(withDuration: 0.3) {
                self.view.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height/8, width: self.view.frame.width, height: self.view.frame.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewDidScroll (_ scrollView: UIScrollView){
        let offsetY = scrollView.contentOffset.y
        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let buffer: CGFloat = self.cellBuffer * 90
        
        let indexPath = classes.indexPathsForVisibleRows
        let sectionNumber = indexPath?[0].section
        
        print (sectionNumber)
        if (sectionNumber! > 0 && sectionNumber != nil){
            today.isHidden = false;
        }else{
            today.isHidden = true;
        }
        
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
    
    func getNextDay(_ date: Date, _ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: date)!
    }
    
    func dateToString(_ date: Date) -> String{
        dateFormatter.dateFormat = "EE"
        let nameOfDay = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "LLLL"
        let month = dateFormatter.string(from: date)
        let day = calendar.component(.day, from: date)
        return "\(nameOfDay) \(month), \(day)"
    }
    
    
}
