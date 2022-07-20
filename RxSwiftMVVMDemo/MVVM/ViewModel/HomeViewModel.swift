//
//  HomeViewModel.swift
//  RxSwiftMVVMDemo
//
//  Created by Admin on 14/07/22.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit


class HomeViewModel {
    
    var tableData = BehaviorRelay<[PostData]>(value: [])
    var filteredItems: BehaviorRelay<[PostData]> = BehaviorRelay(value: [])
 
    let searchText = BehaviorRelay<String>(value: "")
    var listItems: Observable<[PostData]> {
        return filteredItems.asObservable()
    }
    
    var isDataLoading = true
    var limit = 150
  
    
    //MARK:- API CALL
    func fetchData(vc:UIViewController) {
        print(limit)
        vc.startLoading()
        HomeEndPoint.photos(limit: limit).instance.executeQuery { (response: PostModel) in
           
          
            vc.stopLoading()
            self.tableData.accept(response.data ?? [])
            self.filteredItems.accept(self.tableData.value)
            self.isDataLoading = false
            
        } error: { (errorMsg) in
            vc.stopLoading()
            print(errorMsg, "Something went wrong!")
        }
    }
    
}




