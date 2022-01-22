//
//  BottomCheetViewController.swift
//  BottomCheetTask
//
//  Created by Mostafa on 22/01/2022.
//

import UIKit

enum ContainerStatus {
    case up
    case down
}

typealias ObservableClosure = (_ value: CGFloat, _ status: ContainerStatus)-> Void

class BottomCheetViewController: UIViewController {

    //MARK:- Layout:-
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variable:-
    var colors = [
        "#C0C0C0", "#808080","#d7e9f5","#d35400","#ecf0f1",
        "#00FFFF","#008080","#000080","#FF00FF","#800080",
        "#72484c","#2c3e50","#7f8c8d","#e67e22","#a4305e"]
    var observable: ObservableClosure?
    var maxHeight: CGFloat = 0
    let defaultHeight: CGFloat = 200
    var lastHeight: CGFloat = 200
    var containerHeight: CGFloat = 200
    
    //MARK:- Life Cycle:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
    }
    
    
}

//MARK:- Table View Data Source
extension BottomCheetViewController: UITableViewDataSource {
   
    func setupTableView(){
        self.tableView.register(cell: BottomCheetTableCell.self)
        self.tableView.backgroundColor = .red
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as BottomCheetTableCell
        cell.backgroundColor = UIColor(hex: colors[indexPath.row])
        return cell
    }
    
}


extension BottomCheetViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
        
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y

        if offset < -50 {
            self.lastHeight = 200
            self.containerHeight = 200
            self.tableView.isScrollEnabled = false
            self.observable?(0,.down)
        }

    }
    
}


extension BottomCheetViewController {
    

    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        if translation.y < 0   {
            self.contanierChanged(by: translation.y,.up)
        }else {
            self.contanierChanged(by: translation.y, .down)
        }
        
        if sender.state == .ended {
            self.lastHeight = self.containerHeight
        }
    }

    func contanierChanged(by value: CGFloat, _ containerStatus: ContainerStatus){
        switch containerStatus {
        case .down:
            if self.containerHeight >= self.defaultHeight {
                self.tableView.isScrollEnabled = false
                self.containerHeight = self.lastHeight - value
                self.observable?(value, .down)

            }
        case .up:

            if self.containerHeight <= self.maxHeight && (-value < (self.maxHeight - defaultHeight) ) {
                self.containerHeight = self.lastHeight + (-value)
                self.observable?(value, .up)

            }
        }
    }

}


