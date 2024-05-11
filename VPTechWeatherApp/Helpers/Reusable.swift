//
//  Reusable.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import UIKit

protocol Reusable {
    static var nib: UINib { get }
    static var nibName: String { get }
    static var reuseIdentifier: String { get }
}

extension Reusable where Self: UIView {
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<Cell: Reusable>(_: Cell.Type) where Cell: UITableViewCell {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func registerNib<Cell: Reusable>( _: Cell.Type) where Cell: UITableViewCell {
        register(Cell.nib, forCellReuseIdentifier: Cell.reuseIdentifier)
    }

    func registerTableViewHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<Cell: UITableViewCell>(
        forIndexPath indexPath: IndexPath
    ) -> Cell where Cell: Reusable {
        return dequeueReusableCell(
            withIdentifier: Cell.reuseIdentifier,
            for: indexPath
        ) as! Cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: Reusable {
        return dequeueReusableHeaderFooterView(
            withIdentifier: T.reuseIdentifier
        ) as! T
    }
}
