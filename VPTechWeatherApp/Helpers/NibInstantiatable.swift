//
//  NibInstantiatable.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import UIKit

protocol NibInstantiatable {}
extension NibInstantiatable where Self: UIView {
    static func loadFromNib() -> Self? {
        let name = String(describing: self)
        return UINib(nibName: name, bundle: nil)
            .instantiate(withOwner: self)
            .first(where: { $0 is Self}) as? Self
    }
}
