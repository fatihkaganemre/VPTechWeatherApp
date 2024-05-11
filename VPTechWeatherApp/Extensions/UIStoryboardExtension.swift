//
//  UIStoryboardExtension.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 11/05/2024.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        guard let id = NSStringFromClass(T.self).components(separatedBy: ".").last,
              let viewController = instantiateViewController(withIdentifier: id) as? T else {
            fatalError("Could not instantiate view controller \(T.self) from storyboard \(self)")
        }
        return viewController
    }
    
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

