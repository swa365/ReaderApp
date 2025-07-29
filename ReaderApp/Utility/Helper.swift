
//  Helper.swift
//  ReaderApp
//  Created by swaim yadav on 27/07/25.

import UIKit

extension UITextField {
      
    func setupLeftImage(imageName:String){
    
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        leftView = imageContainerView
        leftViewMode = .always
        self.tintColor = .lightGray
        
      }

   }
