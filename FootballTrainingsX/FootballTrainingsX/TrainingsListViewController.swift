//
//  TrainingsListViewController.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 25/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class TrainingsListViewController: UIViewController {
    // MARK: - Переменные
    private var trainings = [MOTraining]() // футбольные упражнения
    private let reuseID = "TrainingCell"
    private let stack = CoreDataStack.shared
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainings = stack.loadFromMemory()
        setupUI()
    }
    
    private func setupUI() {
        title = "Выберите тренировку"
        
        let tableView = UITableView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: view.frame.width,
                                                  height: view.frame.height))
        tableView.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
}

// MARK: - UITableViewDataSource
extension TrainingsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
        cell?.backgroundColor = .darkGray
        let training = trainings[indexPath.row]
        let type = training.type
        cell?.textLabel?.text = type
        cell?.textLabel?.textColor = .white
        return cell!
    }
    
}

// MARK: - UITableViewDelegate
extension TrainingsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let training = trainings[indexPath.row]
        let attributedText = makeAttributedText(from: training.type)
        let trainingVC = TrainingViewController()
        trainingVC.trainingIndex = indexPath.row
        trainingVC.urlString = training.urlString
        trainingVC.titleLabel.attributedText = attributedText
        trainingVC.descriptionTextView.text = training.trainingDescription
        trainingVC.delegate = self
        navigationController?.pushViewController(trainingVC, animated: true)
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
}

// MARK: - TrainingViewDelegate
extension TrainingsListViewController: TrainingViewDelegate {
    func save(numberOfReps: Int, successfulReps: Int, at index: Int) {
        trainings[index].numberOfReps += Int16(numberOfReps)
        trainings[index].successfulReps += Int16(successfulReps)
        stack.save(trainings)
    }
}
