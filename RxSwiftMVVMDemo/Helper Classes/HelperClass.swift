//
//  HelperClass.swift
//  MTH
//
//  Created by Sachin on 25/03/21.
//

import Foundation
import UIKit
import SDWebImage




class Helper {
  
    class func showImage(imageView:UIImageView,url:String,isHidePlaceholder:Bool = true,placeholderImg:UIImage = UIImage.init(named: "SM-placeholder")!,isShowIndicator:Bool = true){
        let imageUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        //  print(URL(string: imageUrl))
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        if isShowIndicator == true{ imageView.sd_imageIndicator?.startAnimatingIndicator()}else{imageView.sd_imageIndicator = nil}
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage:  isHidePlaceholder ?  nil : placeholderImg, options: .highPriority) { (image, error, cachetype, url) in
            
            imageView.sd_imageIndicator?.stopAnimatingIndicator()
        }
    }
    
    
}

func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
    
}
