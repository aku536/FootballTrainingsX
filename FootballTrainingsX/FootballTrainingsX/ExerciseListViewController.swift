//
//  ExerciseListViewController.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 25/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ExerciseListViewController: UIViewController {
    // MARK: - Переменные
    private var exercisesList = [Exercise]() // футбольные упражнения
    private let reuseID = "ExerciseCell"
    private let stack = CoreDataStack.shared
    
    // MARK: - ViewController lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exercisesList = stack.loadFromMemory()
        setupUI()
    }
    
    // MARK: - Настройка UI
    private let exerciseListView = ExerciseListView()
    
    private func setupUI() {
        navigationController?.navigationBar.topItem?.title = "Выберите упражнение"
        
        exerciseListView.frame = view.frame
        view.addSubview(exerciseListView)
        
        exerciseListView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        exerciseListView.tableView.dataSource = self
        exerciseListView.tableView.delegate = self
    }
    
}

// MARK: - UITableViewDataSource
extension ExerciseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercisesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) else {
            return UITableViewCell()
        }
        cell.backgroundColor = .darkGray
        let exercise = exercisesList[indexPath.row]
        let type = exercise.type
        cell.textLabel?.text = type
        cell.textLabel?.textColor = .white
        cell.accessoryType = .disclosureIndicator
        if let image = UIImage(named: type) {
            cell.imageView?.image = image
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ExerciseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exercise = exercisesList[indexPath.row]
        let exerciseVC = ExerciseViewController(exercise: exercise)
        navigationController?.pushViewController(exerciseVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
