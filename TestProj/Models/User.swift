//
//  User.swift
//  TestProj
//
//  Created by Igor Zharii on 02.03.2021.
//

struct User: Codable {
    let login: String
    let avatarUrl: String
    let publicRepos: Int
    let reposUrl: String?
    let email: String?
    let location: String?
    let createdAt: String
    let followers: Int
    let following: Int
    let bio: String?
}
