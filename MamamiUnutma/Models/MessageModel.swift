//
//  MessageModel.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 1.11.2021.
//

import Foundation
import FirebaseFirestore // (1)
import FirebaseFirestoreSwift

struct Message: Codable, Identifiable {
    @DocumentID var id: String? // (2)
    var message: String
    @ServerTimestamp var createdTime: Timestamp? // (3)
    var userId: String?
    var postId: String
    var imageURL: String?
    var userName: String?
}


struct MessageCell: Identifiable {
    @DocumentID var id: String? // (2)
    var message: String
    @ServerTimestamp var createdTime: Timestamp? // (3)
    var userId: String?
    var postId: String
    var position: BubblePosition
    var imageURL: String?
    var userName: String?
    var color: String?
    init(id: String?, message: String, createdTime: Timestamp?, userId: String?, postId: String, position: BubblePosition, imageURL: String?, userName: String?, color: String?) {
        self.position = position
        self.id = id
        self.message = message
        self.createdTime = createdTime
        self.userId = userId
        self.postId = postId
        self.imageURL = imageURL
        self.userName = userName
        self.color = color
        
    }
}


