//
//  ViewController.swift
//  BottomCheetTask
//
//  Created by Mostafa on 22/01/2022.
//f

import UIKit


class ViewController: UIViewController {
    
    //MARK:- Layout:-
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    

    //MARK:- Life Cycle:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizerAction))
        view.addGestureRecognizer(gesture)
        
    }
  
    @objc func gestureRecognizerAction(){
        UIView.animate(withDuration: 0.5) {
            self.containerHeight.constant = 200
            self.view.layoutIfNeeded()
        }
    }
    
}

extension ViewController {
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bottomVC = segue.destination as! BottomCheetViewController
        
        bottomVC.maxHeight = (self.view.bounds.size.height / 1.15)
        bottomVC.observable = { [weak self]  value, status in
            guard let self = self else {return}
            
            switch status {
            case .up:
                if bottomVC.containerHeight <= bottomVC.maxHeight {
                    self.containerHeight.constant = bottomVC.lastHeight + (-value)
                }else {
                    bottomVC.tableView.isScrollEnabled = true
                }
            case .down:
                if bottomVC.containerHeight >= bottomVC.defaultHeight {
                    UIView.animate(withDuration: 0.5) {
                        self.containerHeight.constant = bottomVC.lastHeight - value
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
        
    }

}

