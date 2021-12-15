//
//  Extension.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/14.
//

import UIKit.NSLayoutConstraint

extension UIView {
    func setPosition(top: NSLayoutYAxisAnchor?,
                     topConstant: CGFloat = .zero,
                     bottom: NSLayoutYAxisAnchor?,
                     bottomConstant: CGFloat = .zero,
                     leading: NSLayoutXAxisAnchor?,
                     leadingConstant: CGFloat = .zero,
                     trailing: NSLayoutXAxisAnchor?,
                     trailingConstant: CGFloat = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        top.flatMap {
            topAnchor.constraint(equalTo: $0, constant: topConstant).isActive = true
        }
        
        bottom.flatMap {
            bottomAnchor.constraint(equalTo: $0, constant: bottomConstant).isActive = true
        }
        
        leading.flatMap {
            leadingAnchor.constraint(equalTo: $0, constant: leadingConstant).isActive = true
        }
        
        trailing.flatMap {
            trailingAnchor.constraint(equalTo: $0, constant: trailingConstant).isActive = true }
    }
    
    func addBackground(imageName:String) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0,
                                                            width: width, height: height))
        imageViewBackground.image = UIImage(named: imageName)
        
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension UIViewController {
    func findParentViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
