//
//  User.swift
//  TestProj
//
//  Created by Igor Zharii on 02.03.2021.
//

struct SearchUser: Codable {
    let login: String
}

struct Users: Codable {
    let items: [SearchUser]
}

