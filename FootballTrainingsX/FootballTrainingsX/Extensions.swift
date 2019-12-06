//
//  Extensions.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 27/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

extension String {
    /// Рассчитывает высоту текста, исходя из ширины и шрифта
    ///
    /// - Parameters:
    ///   - width: ширина текста
    ///   - font: шрифт
    /// - Returns: высота текста
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// Рассчитывает ширину текста, исходя из высоты и шрифта
    ///
    /// - Parameters:
    ///   - height: высота текста
    ///   - font: шрифт
    /// - Returns: ширина текста
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UIColor {
    /// Принимает rgb значения, конвертирует под формат и возвращает цвет
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIImage {
    /// Создает изображение заданного размера
    func scaledTo(size newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }
}
