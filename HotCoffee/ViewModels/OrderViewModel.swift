//
//  OrderViewModel.swift
//  HotCoffee
//
//  Created by İbrahim Bayram on 18.05.2023.
//


import Foundation

struct OrderListViewModel {
    var orderViewModels : [OrderViewModel]
    
    init() {
        self.orderViewModels = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    func oderViewModel(at index : Int) -> OrderViewModel {
        return orderViewModels[index]
    }
}


// MARK: - ViewModel of our model -

struct OrderViewModel {
    let order : Order
}

extension OrderViewModel {
    
    var name : String {
        return order.name
    }
    
    var email : String {
        return order.email
    }
    
    var type : String {
        return order.type.rawValue.capitalized
    }
    
    var size : String {
        return order.size.rawValue.capitalized
    }
}
