//
//  Error.swift
//  DoTryCatch
//
//  Created by Prashuk Ajmera on 6/26/21.
//

import Foundation

enum LoginError: Error {
    case invalidEmail
    case incorrectPasswordLength
    case incompleteForm
}
