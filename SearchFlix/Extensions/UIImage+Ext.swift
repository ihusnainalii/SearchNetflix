//
//  UIImage.swift
//  SearchFlix
//
//  Created by Husnian Ali on 24.02.2025.
//

import UIKit

extension UIImage {
    static func fromImage(_ image: UIImage?) -> UIImage {
        guard let image else {
            return UIImage(named: "na") ?? UIImage()
        }
        return image
    }
}
