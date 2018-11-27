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
        addBottomSheetView()
    }
    
    func addBottomSheetView() {
        let container = storyboard!.instantiateViewController(withIdentifier: "BottomView")
        
        self.addChild(container)
        self.view.addSubview(container.view)
        container.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        container.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
}

