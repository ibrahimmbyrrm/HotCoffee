//
//  AddCoffeOrderViewModel.swift
//  HotCoffee
//
//  Created by İbrahim Bayram on 18.05.2023.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name : String?
    var email : String?
    var selectedSize : String?
    var selectedType : String?
    
    var types : [String] {
        return CoffeType.allCases.map() { $0.rawValue.capitalized }
    }
    
    var sized : [String] {
        return CoffeSize.allCases.map() { $0.rawValue.capitalized}
    }
}
