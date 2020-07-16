//
//  ViewControllerExtension.swift
//  WeatherLogger
//
//  Created by Akanksha garg on 16/07/20.
//  Copyright © 2020 Akanksha garg. All rights reserved.
//

import UIKit

/// This is a extension class of ViewController, to handle tableview delegates separately
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
}
