//
//  ItemData.swift
//  MemoryMatch
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

struct ProductData: Codable {
    let products : [Product]
}

struct Product: Codable {
    let id: Int
    let title: String
    let image: Image
}

struct Image: Codable {
    let src: String
}
