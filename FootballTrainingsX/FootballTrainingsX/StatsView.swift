//
//  StatsView.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 04/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class StatsView: UIView {
    // MARK: - Настройка UI
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.text = "Результаты"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    /// Обнуление статистики
    let resetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .black
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        return tableView
    }()
    
    private func setupUI() {
        let offset: CGFloat = 25
        let titleLabelWidth = frame.width - offset
        let titleLabelHeight: CGFloat = titleLabel.text?.height(withConstrainedWidth: titleLabelWidth, font: titleLabel.font) ?? 70
        let resetButtonHeight: CGFloat = 20
        
        backgroundColor = .black
        
        titleLabel.frame = CGRect(x: offset, y: 2 * offset, width: titleLabelWidth - 2*resetButtonHeight, height: titleLabelHeight)
        addSubview(titleLabel)
        
        resetButton.frame = CGRect(x: titleLabel.frame.maxX, y: titleLabel.frame.minY + 15, width: resetButtonHeight, height: resetButtonHeight)
        addSubview(resetButton)
        
        tableView.frame = CGRect(x: 0, y: titleLabel.frame.maxY + offset, width: frame.width , height: frame.height - titleLabel.frame.height)
        addSubview(tableView)
    }
}
