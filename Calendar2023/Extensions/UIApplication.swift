//
//  UIApplication.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 15.02.2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
