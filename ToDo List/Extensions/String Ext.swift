//
//  String Ext.swift
//  ToDo List
//
//  Created by Евгений Пашко on 10.12.2021.
//

// New properties for String, replace small sumbol 
extension String {
    var capitilizedWithSpaces: String {
        let withSpace = reduce("") { result, character in
            character.isUppercase ? "\(result) \(character)" : "\(result)\(character)"
        }
        
        return withSpace.capitalized
    }
}
