//
//  OCRCourseViewController.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 12/12/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class OCRCourseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Ran")

        // Do any additional setup after loading the view.
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
