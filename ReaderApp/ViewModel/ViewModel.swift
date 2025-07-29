//
//  ViewModel.swift
//  ReaderApp
//
//  Created by swaim yadav on 26/07/25.
//

import Foundation

protocol NewsDelegate : AnyObject{
    func getApiData(data : NewsResponse?)
}

struct ViewModel {
    
    var delegate : NewsDelegate?
    
    func ApiCall(){
        ServerManager.newsApiServer { data, error in
            guard let ddelegate = self.delegate else {return}
            ddelegate.getApiData(data: data)
      
          }
            
    }
    
    
}
