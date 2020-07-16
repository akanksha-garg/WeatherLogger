//
//  ViewController.swift
//  WeatherLogger
//
//  Created by Akanksha garg on 16/07/20.
//  Copyright © 2020 Akanksha garg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherInfoTableView: UITableView!
    // MARK: - Variables
    let weatherVM = WeatherViewModel()
    private let control: UIRefreshControl = UIRefreshControl()
    let estimatedRowHeight = 450.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

