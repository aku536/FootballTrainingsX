//
//  StatsViewController.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 02/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit
import Intents
import CoreSpotlight

class StatsViewController: UIViewController {
    // MARK: - Переменные
    private var exercisesModel: ExerciseModel // футбольные упражнения
    private var percentageCalculator: PercentageCalculatorProtocol
    private let reuseID = "StatsCell"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Инициализация
    init(exerciseModel: ExerciseModel, percentageCalculator: PercentageCalculatorProtocol) {
        self.exercisesModel = exerciseModel
        self.percentageCalculator = percentageCalculator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserActivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        statsView.resetButton.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
    }
    
    // MARK: - Настройка UI
    private lazy var statsView = StatsView()
    
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
        exercisesModel.resetStats()
    }
    
    // Добавление голосовой команды
    private func addUserActivity() {
        let activity = NSUserActivity(activityType: "com.krrl.FootballTrainingsX.showStats")
        activity.title = "Показать результаты"
        if #available(iOS 12.0, *) {
            activity.suggestedInvocationPhrase = "Покажи результаты футбольных тренировок"
            activity.isEligibleForPrediction = true
            activity.isEligibleForSearch = true
        }
        let attributes =  CSSearchableItemAttributeSet(itemContentType:"NSUserActivity.searchableItemContentType")
        if let image = UIImage(named: "x1240") {
            attributes.thumbnailData = image.pngData()
        }
        attributes.contentDescription = "Открыть экран статистики"
        activity.contentAttributeSet = attributes
        userActivity = activity
    }
}

// MARK: - UITableViewDataSource
extension StatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercisesModel.exercisesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as? StatsTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .darkGray
        let training = exercisesModel.exercisesList[indexPath.row]
        let type = training.type
        let reps = training.numberOfReps
        let successfulReps = training.successfulReps
        cell.exerciseImageView.image = UIImage(named: type)
        cell.exerciseTitleLabel.text = type
        cell.repsLabel.text = "Всего: \(reps)"
        cell.successLabel.text = "Успешно: \(successfulReps)"
        cell.percentageLabel.text = percentageCalculator.calculatePercenatge(count: String(successfulReps), total: String(reps))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
