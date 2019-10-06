//
//  ViewController.swift
//  PomodoroApp
//
//  Created by Edno Fedulo on 05/10/19.
//  Copyright © 2019 Fedulo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    lazy private var timerView: CircularIndicator = {
        let view = CircularIndicator()

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:1.00, green:0.25, blue:0.21, alpha:1.0)
        self.view.addSubview(timerView)

        timerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            timerView.widthAnchor.constraint(equalToConstant: 200),
            timerView.heightAnchor.constraint(equalToConstant: 200)
            ])

        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnView)))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    @objc func didTapOnView(){
        DispatchQueue.main.async {
            self.timerView.start(withDuration: 5)
        }

    }

    /*@objc func ff(){
        
    }*/


}

