//
//  EmployeeViewModel.swift
//  MVVM-API
//
//  Created by Prashuk Ajmera on 12/13/20.
//

import Foundation

class EmployeeViewModel: NSObject {
    
    private var apiService = APIService()
    
    private(set) var empData : Employee! {
        didSet {
            self.bindEmployeeViewModelToController()
        }
    }
    
    var bindEmployeeViewModelToController: (() -> ()) = {}
            
    override init() {
        super.init()
        self.callFuncToGetEmpData()
    }
    
    func callFuncToGetEmpData() {
        self.apiService.apiToGetEmployee { [weak self] (empData) in
            guard let self = self else { return }
            self.empData = empData
        }
    }
}
