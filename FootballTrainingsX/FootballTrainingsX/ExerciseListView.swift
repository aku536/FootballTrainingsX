//
//  ExerciseListView.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 04/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ExerciseListView: UIView {
    // MARK: - Настройка UI
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .black
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private func setupUI() {
        tableView.frame = frame
        addSubview(tableView)
    }

}
