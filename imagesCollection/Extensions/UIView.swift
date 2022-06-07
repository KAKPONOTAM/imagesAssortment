import Foundation
import UIKit

extension UIView {
    func roundingView(cornerRadius: CGFloat = 5) -> Self {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        return self
    }
}

