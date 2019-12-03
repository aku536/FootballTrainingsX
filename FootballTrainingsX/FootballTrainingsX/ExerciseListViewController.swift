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
    override func viewDidLoad() {
        super.viewDidLoad()
        exercisesList = stack.loadFromMemory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: - Настройка UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.backgroundColor = .black
        tableView.tableFooterView = UIView()
        tableView.register(ExerciseListTableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private func setupUI() {
        title = "Выберите упражнение"
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.frame.width,
                                 height: view.frame.height)
        
        view.addSubview(tableView)
    }

}

// MARK: - UITableViewDataSource
extension ExerciseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercisesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as? ExerciseListTableViewCell else {
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
        let attributedText = makeAttributedText(from: exercise.type)
        let exerciseVC = ExerciseViewController()
        exerciseVC.exerciseIndex = indexPath.row
        exerciseVC.urlString = exercise.urlString
        exerciseVC.titleLabel.attributedText = attributedText
        exerciseVC.descriptionTextView.text = exercise.trainingDescription
        exerciseVC.delegate = self
        navigationController?.pushViewController(exerciseVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Преобразуем текст для заголовка
    private func makeAttributedText(from text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white,
            .underlineStyle : NSUnderlineStyle.single.rawValue,
            .font : UIFont(name: "TimesNewRomanPS-BoldMT", size: 40)!
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - TrainingViewDelegate
extension ExerciseListViewController: ExerciseViewDelegate {
    func save(numberOfReps: Int, successfulReps: Int, at index: Int) {
        exercisesList[index].numberOfReps += Int16(numberOfReps)
        exercisesList[index].successfulReps += Int16(successfulReps)
        for exercise in exercisesList {
            stack.save(exercise)
        }
    }
}
