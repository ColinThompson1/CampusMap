//
//  ViewController.swift
//  CMScheduleExt
//
//  Created by Colin Thompson on 2018-10-24.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       //addBottomSheetView()
    }
    
    func addBottomSheetView() {
        let bottomVC = storyboard!.instantiateViewController(withIdentifier: "BottomView")
        
        self.addChild(bottomVC)
        self.view.addSubview(bottomVC.view)
        bottomVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        bottomVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    

}

