//
//  UIView+Extension.swift
//  sample
//
//  Created by Leandro Berli on 21/10/2022.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - Custom Functions
    static func instantiateFromNib() -> Self? {
        func instanceFromNib<T: UIView>() -> T? {
            return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil).first as? T
        }
        
        return instanceFromNib()
    }
}
