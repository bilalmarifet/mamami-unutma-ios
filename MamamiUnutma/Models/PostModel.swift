//
//  PostModel.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 26.10.2021.
//
import Foundation
import FirebaseFirestore // (1)
import FirebaseFirestoreSwift

struct Post: Codable, Identifiable {
    @DocumentID var id: String? // (2)
    var title: String
    var description: String
    @ServerTimestamp var createdTime: Timestamp? // (3)
    var userId: String?
    var latitude: Double?
    var longitude: Double?
    var image: String?
    var username: String?
}
