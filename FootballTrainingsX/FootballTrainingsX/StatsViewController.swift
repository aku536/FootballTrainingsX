//
//  StatsViewController.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 02/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    // MARK: - Переменные
    private var exercisesList = [Exercise]() // футбольные упражнения
    private let reuseID = "StatsCell"
    private let stack = CoreDataStack.shared
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        tableView.backgroundColor = .black
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exercisesList.removeAll()
        exercisesList = stack.loadFromMemory()
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.reloadData()
        
    }
    let tableView = UITableView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 0,
                                              height: 0), style: .grouped)

}

// MARK: - UITableViewDataSource
extension StatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercisesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as? StatsTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .darkGray
        let training = exercisesList[indexPath.row]
        let type = training.type
        let reps = training.numberOfReps
        let successfulReps = training.successfulReps
        cell.exerciseImageView.image = UIImage(named: type)
        cell.exerciseLabel.text = type
        cell.repsLabel.text = "Всего: \(reps)"
        cell.successLabel.text = "Успешно: \(successfulReps)"
        cell.percentageLabel.text = PercentageCalculator.calculatePercenatge(count: String(successfulReps), total: String(reps))
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension StatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
