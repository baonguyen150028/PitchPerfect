//
//  UIViewExtensions.swift
//  FadeExtensionDemo_Completed
//
//  Created by The Bao on 10/01/16.
//  Copyright (c) 2015 The Bao. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView (Extensions)

extension UIView {
    
    func fadeOut(duration: TimeInterval, delay: TimeInterval, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
    
    func fadeIn(duration: TimeInterval, delay: TimeInterval, completion:((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, delay:delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)
    }
    func fadeOutAndIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: [.repeat, .autoreverse], animations: {
            self.alpha = 0.3
            },
                       completion: ({finished in
                        if finished {
                            UIView.animate(withDuration: duration, delay: delay, options: [.repeat, .autoreverse], animations: {
                                self.alpha = 1.0
                                }, completion: nil)
                        }
                       }))
    }
}
