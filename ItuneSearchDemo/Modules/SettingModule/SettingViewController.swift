//
//  SettingViewController.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import UIKit

final class SettingViewController: UIViewController {
    private let testingLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "SettingViewController"
        
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        view.backgroundColor = .white
        view.addSubview(testingLabel)
        
        testingLabel.translatesAutoresizingMaskIntoConstraints = false
        testingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        testingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}
