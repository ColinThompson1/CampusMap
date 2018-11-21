//
//  BottomSheetViewController.swift
//  CMScheduleExt
//
//  Created by Kevin Vo on 2018-11-05.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    var onTop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        view.addGestureRecognizer(pan)        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.tapGesture))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - UIScreen.main.bounds.height/8
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
        
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
