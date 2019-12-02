//
//  StatsViewController.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 02/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    private var trainings = [MOTraining]() // футбольные упражнения
    private let reuseID = "TrainingCell"
    private let stack = CoreDataStack.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        tableView.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trainings.removeAll()
        trainings = stack.loadFromMemory()
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.reloadData()
        
    }
    let tableView = UITableView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 0,
                                              height: 0))

}

// MARK: - UITableViewDataSource
extension StatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
        cell?.backgroundColor = .darkGray
        let training = trainings[indexPath.row]
        let type = training.type
        let reps = training.numberOfReps
        cell?.textLabel?.text = type + "\(reps)"
        cell?.textLabel?.textColor = .white
        return cell!
    }
    
}

// MARK: - UITableViewDelegate
extension StatsViewController: UITableViewDelegate {

}
