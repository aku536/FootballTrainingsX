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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ViewController lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exercisesList.removeAll()
        exercisesList = stack.loadFromMemory()
        setupUI()
        statsView.resetButton.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
    }
    
    // MARK: - Настройка UI
    private let statsView = StatsView()
    
    private func setupUI() {
        statsView.frame = view.frame
        view.addSubview(statsView)
        
        statsView.tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: reuseID)
        statsView.tableView.delegate = self
        statsView.tableView.dataSource = self
        statsView.tableView.reloadData()
    }
    
    // MARK: - Приватные методы
    
    // Выводит предупреждении о сбросе статистики
    @objc private func presentAlert() {
        let alertController = UIAlertController(title: "Вы хотите сбросить всю статистику?", message: "Удаленные данные невозможно восстановить", preferredStyle: .alert)
        let action = UIAlertAction(title: "Сбросить",
                                   style: .destructive,
                                   handler: { (action: UIAlertAction) in
                                    self.resetStats()
                                    self.statsView.tableView.reloadData()
        })
        alertController.addAction(action)
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // Обнуление статистики
    private func resetStats() {
        for index in exercisesList.indices {
            exercisesList[index].numberOfReps = 0
            exercisesList[index].successfulReps = 0
            stack.save(exercisesList[index])
        }
    }
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
