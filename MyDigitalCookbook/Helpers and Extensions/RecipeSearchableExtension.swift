//
//  RecipeSearchableExtension.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 3/4/21.
//

import Foundation
import CoreData

// MARK: - Protocol
protocol SearchableRecordDelegate {
    func matches(searchTerm: String) -> Bool
}//End of protocol

extension Recipe: SearchableRecordDelegate {
    func matches(searchTerm: String) -> Bool {
        guard let name = self.name else { return false }
        if name.lowercased().contains(searchTerm.lowercased()) {
            return true
        }
        return false
    }
}//End of Extension
