//
//  ViewController.swift
//  ScheduleBuilder
//
//  Created by Xian-Meng Low on 2018-11-01.
//  Copyright © 2018 Xian-Meng Low. All rights reserved.
//

import UIKit
import os.log
import ScrollableDatepicker

var courses = [Class] ()

var mon = [Class]()
var tue = [Class]()
var wed = [Class]()
var thu = [Class]()
var fri = [Class]()
var sat = [Class]()
var sun = [Class]()
var classData = CourseData().getData()
//classData["CPSC 313"]!["perdiodics"]!["Lecture 1"]!

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var today: UIButton!
    
    var onTop = false

    @IBOutlet weak var classes: UITableView!
    @IBOutlet weak var datePicker: ScrollableDatepicker!{
        didSet {
            var dates = [Date]()
            for day in -15...200000 {
                dates.append(Date(timeIntervalSinceNow: Double(day * 86400)))
            }
            
            datePicker.dates = dates
            datePicker.selectedDate = Date()
            datePicker.delegate = self as? ScrollableDatepickerDelegate
            
            var configuration = Configuration()
            
            // weekend customization
            configuration.weekendDayStyle.dateTextColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
            configuration.weekendDayStyle.dateTextFont = UIFont.boldSystemFont(ofSize: 20)
            configuration.weekendDayStyle.weekDayTextColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
            
            // selected date customization
            configuration.selectedDayStyle.backgroundColor = UIColor(white: 0.9, alpha: 1)
            configuration.daySizeCalculation = .numberOfVisibleItems(5)
            
            datePicker.configuration = configuration
        }
    }
    private var data: [String] = []



    var events:[Date:[Class]] = [:]
    
    var count = 0
    var currentSectionAmount = 4
    let cellBuffer: CGFloat = 2
   
    let date = Date()
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    
    var fetchingMore = false
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.classes.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return ((events[getNextDay(date, indexPath.section)]?.count)! > 0)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing{
            return .delete
        }
        
        return .none
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let courseToBeDeleted = events[getNextDay(date, indexPath.section)]![indexPath.row]
        let index = courses.index(of: courseToBeDeleted)
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            courses.remove(at: index!)
            self.saveEvents()
            NotificationCenter.default.post(name: .reload, object: nil)
        })
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let courseToBeDeleted = events[getNextDay(date, indexPath.section)]![indexPath.row]
            let index = courses.index(of: courseToBeDeleted)
            courses.remove(at: index!)
            saveEvents()
            NotificationCenter.default.post(name: .reload, object: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return currentSectionAmount + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return dateToString(getNextDay(date, section))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dateFormatter.dateFormat = "EEEE"
        if ((dateFormatter.string(from: getNextDay(date, section))) == "Monday"){
            if (mon.count > 0){
                events[getNextDay(date, section)] = mon.filter({$0.getStartDate("Mon") <= getNextDay(date, section) && $0.getEndDate("Mon") >= getNextDay(date, section)})
            }else{
                events[getNextDay(date, section)] = mon
            }
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Tuesday"){
            if (tue.count > 0){
                events[getNextDay(date, section)] = tue.filter({$0.getStartDate("Tue") <= getNextDay(date, section) && $0.getEndDate("Tue") >= getNextDay(date, section)})
            }else{
                events[getNextDay(date, section)] = tue
            }
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Wednesday"){
            if (wed.count > 0){
                events[getNextDay(date, section)] = wed.filter({$0.getStartDate("Wed") <= getNextDay(date, section) && $0.getEndDate("Wed") >= getNextDay(date, section)})
            }else{
                events[getNextDay(date, section)] = wed
            }
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Thursday"){
            if (thu.count > 0){
                events[getNextDay(date, section)] = thu.filter({$0.getStartDate("Thu") <= getNextDay(date, section) && $0.getEndDate("Thu") >= getNextDay(date, section)})
            }else{
                events[getNextDay(date, section)] = thu
            }
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Friday"){
            if (fri.count > 0){
                events[getNextDay(date, section)] = fri.filter({$0.getStartDate("Fri") <= getNextDay(date, section) && $0.getEndDate("Fri") >= getNextDay(date, section)})
            }else{
                events[getNextDay(date, section)] = fri
            }
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Saturday"){
            if (sat.count > 0){
                events[getNextDay(date, section)] = sat.filter({$0.getStartDate("Sat") <= getNextDay(date, section) && $0.getEndDate("Sat") >= getNextDay(date, section)})
            }else{
                events[getNextDay(date, section)] = sat
            }
        }else if ((dateFormatter.string(from: getNextDay(date, section))) == "Sunday"){
            if (sun.count > 0){
                events[getNextDay(date, section)] = sun.filter({$0.getStartDate("Sun") <= getNextDay(date, section) && $0.getEndDate("Sun") >= getNextDay(date, section)})
            }else{
                events[getNextDay(date, section)] = sun
            }
        }
        let some : [Class] = events[getNextDay(date, section)]!
        if (some.count > 0){
            return (some.count)
        }else{
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ClassesViewCell"
        
        guard let cell = classes.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventsTableViewCell else{
            fatalError("The dequed cell is not an instance of EventsTableViewCell")
        }
        
        let listOfEvents : [Class] = events[getNextDay(date, indexPath.section)]!
        if (listOfEvents.count == 0){
            cell.contentView.backgroundColor = UIColor.gray
            cell.startTime.text = ""
            cell.endTime.text = ""
            cell.eventName.text = "No events here"
            return cell
        }else{
            cell.contentView.backgroundColor = UIColor.white
            let currentEvent = listOfEvents[indexPath.row]
            
            var name :String = ""
            name = (events[getNextDay(date, indexPath.section)]![indexPath.row]).name
            
            let type: String = (events[getNextDay(date, indexPath.section)]![indexPath.row]).type
            dateFormatter.dateFormat = "EEE"
            cell.startTime.text = currentEvent.getStartTime(dateFormatter.string(from: getNextDay(date, indexPath.section)))
            cell.endTime.text = currentEvent.getEndTime(dateFormatter.string(from: getNextDay(date, indexPath.section)))
            
            cell.eventName.text = name + " | " + type
            
            return cell
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        //loadSampleCourses()
        if let savedEvents = loadEvents() {
            courses += savedEvents
        }
        sortCourses()
        classes.delegate = self
        classes.dataSource = self
        
        view.bringSubviewToFront(today)
        today.setTitle("Today", for: .normal)
        today.isHidden = true

        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(ScheduleViewController.panGesture))
        view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(ScheduleViewController.tapGesture))
        //view.addGestureRecognizer(tap)
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
        //view.backgroundColor = .clear
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
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ScheduleViewController.addClass))
        navigationItem.rightBarButtonItem = rightButton
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
    }
    
    
    @objc func addClass(sender: UIBarButtonItem) {
        
        let addVC = storyboard!.instantiateViewController(withIdentifier :"AddClass") as! ClassSelectorViewController
        self.present(addVC, animated: true)
        
        // reset the location of the card
        onTop = false
    }
    
    /*private func loadSampleCourses() {

        let course1 = Class(name: "CPSC 575", type: "Lecture 01", semester: "Fall", days: ["Mon": "13:00 - 14:00", "Wed": "13:00 - 14:00", "Fri": "13:00 - 14:00"])
        let course2 = Class(name: "CPSC 501", type: "Lecture 01", semester: "Fall", days: ["Mon": "14:00 - 15:00", "Wed": "12:00 - 15:00", "Fri": "14:00 - 15:00"])
        let course3 = Class(name: "CPSC 413", type: "Lecture 01", semester: "Fall", days: ["Tue": "13:00 - 14:00", "Thu": "13:00 - 14:00"])
        
        courses.append(course1!)
        courses.append(course2!)
        courses.append(course3!)
    }*/

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
        
        let indexPath = classes.indexPathsForVisibleRows
        let sectionNumber = indexPath?[0].section
        
        if (sectionNumber! > 0 && sectionNumber != nil){
            today.isHidden = false;
        }else{
            today.isHidden = true;
        }
        
        datePicker.selectedDate = getNextDay(date, sectionNumber!)
        
        datePicker.scrollToSelectedDate(animated: true)
        
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
    
    @IBAction func todayButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.classes.scrollToRow(at: indexPath, at: .top, animated: true)
        }
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
    
    public func addCourse(_ course: Class){
        courses.append(course)
        sortCourses()
        saveEvents()
        NotificationCenter.default.post(name: .reload, object: nil)
    }
    
    @objc func reloadTableData(_ notification: Notification) {
        classes.delegate = self
        classes.dataSource = self
        DispatchQueue.main.async { self.classes.reloadData() }
    }
    
    func sortCourses(){
        dateFormatter.dateFormat = "HH:mm"
        
        let monTemp = courses.filter({$0.days.index(forKey: "Mon") != nil})
        let tueTemp = courses.filter({$0.days.index(forKey: "Tue") != nil})
        let wedTemp = courses.filter({$0.days.index(forKey: "Wed") != nil})
        let thuTemp = courses.filter({$0.days.index(forKey: "Thu") != nil})
        let friTemp = courses.filter({$0.days.index(forKey: "Fri") != nil})
        let satTemp = courses.filter({$0.days.index(forKey: "Sat") != nil})
        let sunTemp = courses.filter({$0.days.index(forKey: "Sun") != nil})
        
        mon = monTemp.sorted { dateFormatter.date(from: $0.getStartTime("Mon"))! < dateFormatter.date(from: $1.getStartTime("Mon"))! }
        tue = tueTemp.sorted { dateFormatter.date(from: $0.getStartTime("Tue"))! < dateFormatter.date(from: $1.getStartTime("Tue"))! }
        wed = wedTemp.sorted { dateFormatter.date(from: $0.getStartTime("Wed"))! < dateFormatter.date(from: $1.getStartTime("Wed"))! }
        thu = thuTemp.sorted { dateFormatter.date(from: $0.getStartTime("Thu"))! < dateFormatter.date(from: $1.getStartTime("Thu"))! }
        fri = friTemp.sorted { dateFormatter.date(from: $0.getStartTime("Fri"))! < dateFormatter.date(from: $1.getStartTime("Fri"))! }
        sat = satTemp.sorted { dateFormatter.date(from: $0.getStartTime("Sat"))! < dateFormatter.date(from: $1.getStartTime("Sat"))! }
        sun = sunTemp.sorted { dateFormatter.date(from: $0.getStartTime("Sun"))! < dateFormatter.date(from: $1.getStartTime("Sun"))! }
    }
    
    private func saveEvents() {
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: courses, requiringSecureCoding: false)
            try data.write(to: Class.ArchiveURL)
            os_log("Classes successfully saved.", log: OSLog.default, type: .debug)
        }catch{
            os_log("Failed to save classes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadEvents() -> [Class]?  {
        do{
            let data = try Data(contentsOf: Class.ArchiveURL)
            
            os_log("Classes successfully read.", log: OSLog.default, type: .debug)
            
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Class]
        }catch{
            os_log("Failed to read classes...", log: OSLog.default, type: .error)
        }
        
        return []
    }
    
    fileprivate func showSelectedDate() {
        guard let selectedDate = datePicker.selectedDate else {
            return
        }
    }
    
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

extension ScheduleViewController: ScrollableDatepickerDelegate {
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        showSelectedDate()
    }
    
}
