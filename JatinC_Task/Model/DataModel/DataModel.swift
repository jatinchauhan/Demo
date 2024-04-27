//
//  DataModel.swift
//  JatinC_Task
//
//  Created by Jatin Chauhan on 27/04/24.
//

import Foundation
struct DataModel: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    var detailAPICalled: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId) ?? 0
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        body = try values.decodeIfPresent(String.self, forKey: .body) ?? ""
    }
}
