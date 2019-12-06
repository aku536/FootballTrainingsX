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
    private var exerciseModel: ExerciseModel // футбольные упражнения
    private let reuseID = "ExerciseCell"

    /// Колбэк, который вызывается при тапе на ячейку
    var onExerciseSelect: (() -> Void)?
    
    init(model: ExerciseModel) {
        exerciseModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        return exerciseModel.exercisesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) else {
            return UITableViewCell()
        }
        cell.backgroundColor = .darkGray
        let exercise = exerciseModel.exercisesList[indexPath.row]
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
        exerciseModel.presentedExerciseIndex = indexPath.row
        onExerciseSelect?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
