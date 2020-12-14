//
//  EmployeeViewModel.swift
//  MVVM-API
//
//  Created by Prashuk Ajmera on 12/13/20.
//

import Foundation

class EmployeeViewModel: NSObject {
    
    private var apiService = APIService()
    
    var employee = [EmployeeData]()
        
    override init() {
        super.init()
        self.callFuncToGetEmpData()
    }
    
    func callFuncToGetEmpData() {
        self.apiService.apiToGetEmployee { [weak self] (empData) in
            for item in empData.data {
                self?.employee.append(item)
            }
            
            // Dispatch.main.async {} if we are not following MVVM pattern
        }
    }
}
