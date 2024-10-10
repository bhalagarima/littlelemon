//
//  MenuItem.swift
//  Little Lemon
//
//  Created by Garima Bhala on 2024-09-26.
//

import Foundation

struct MenuItem: Decodable {
    let id: Int
    let title: String
    let image: String
    let price: String
    let description: String?
    let category: String?
}
