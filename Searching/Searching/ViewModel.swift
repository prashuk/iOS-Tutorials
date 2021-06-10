//
//  ViewModel.swift
//  Searching
//
//  Created by Prashuk Ajmera on 1/5/21.
//

import Foundation

class ViewModel: NSObject {
    private var service: Services!

    private(set) var empData: Employee! {
        didSet {
            self.binding()
        }
    }
    
    var binding: (() -> ()) = {}
    
    override init() {
        super.init()
        self.service = Services()
        self.callFuncToGetEmpData()
    }
    
    func callFuncToGetEmpData() {
        self.service.getData { (empData) in
            self.empData = empData
        }
    }
}
