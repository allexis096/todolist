//
//  Item.swift
//  Todoey
//
//  Created by allexis figueiredo on 21/08/22.
//

import Foundation

struct Item: Codable {
    let title: String
    var done: Bool = false
}
