//
//  Tag.swift
//  Tagging
//
//  Created by Sopnil Sohan on 14/10/21.
//

import SwiftUI

struct Tag: Identifiable,Hashable {
    
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
    
    
}
