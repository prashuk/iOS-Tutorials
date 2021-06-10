//
//  Employee.swift
//  MVVM-API
//
//  Created by Prashuk Ajmera on 12/13/20.

import Foundation

// https://app.quicktype.io/

// MARK: - Employee
struct Employee: Codable {
    let data: [EmployeeData]
    let total, page, limit, offset: Int
}

// MARK: - EmployeeData
struct EmployeeData: Codable {
    let id, lastName, firstName, email: String
    let title: Title
    let picture: String
}

enum Title: String, Codable {
    case miss = "miss"
    case mr = "mr"
    case mrs = "mrs"
    case ms = "ms"
}
