//
//  MessagingViewModel.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 1.11.2021.
//

import Foundation
import Resolver
import Combine
import FirebaseAuth
import UIKit
import SwiftUI
class MessagingViewModel: ObservableObject {
    
    
    var colors: [String] = ["BubbleColor-1",
                           "BubbleColor-2",
                           "BubbleColor-3",
                           "BubbleColor-4",
                           "BubbleColor-5",
                           "BubbleColor-6",
                           "BubbleColor-7",
                           "BubbleColor-8",
                           "BubbleColor-9",
                           "BubbleColor-10"]
    var colorToMessages = [String: String]()
    @Published var messageRepository: MessageRepository = Resolver.resolve()
    @Published var postRepository: PostRepository = Resolver.resolve()
    @Published var messagesList = [Message]()
    @Published var messagesCellList = [MessageCell]()
    var post: Post
    var userId: String? = Auth.auth().currentUser?.uid ?? ""
    private var cancellables = Set<AnyCancellable>()
    let firstMessage: MessageCell
    @Published var isPostCreaterIsSelf = false
    @Published var showImagePickerOptions = false
    
    init(post: Post) {
        self.post = post
        var postMessageColor: String?
        if let postUserId = post.userId, let poppedColor = colors.popLast() {
            colorToMessages[postUserId] = poppedColor
            postMessageColor = poppedColor
        }
        self.firstMessage = MessageCell(id: post.id, message: post.description, createdTime: post.createdTime, userId: post.userId, postId: post.id ?? "", position: .center,imageURL: post.image, userName: post.username, color: postMessageColor)
        self.isPostCreaterIsSelf = userId == post.userId
        messageRepository.loadData(postId: post.id ?? "", completion: { [self] messages in
            self.messagesList = messages
            let messagesTemp = messages.map({ [weak self] message -> MessageCell in
                var messageOfColor: String?
                if let userId = message.userId {
                    if let color = self?.colorToMessages[userId] {
                        messageOfColor = color
                    } else {
                        if let colorToGo = self?.colors.popLast() {
                            self?.colorToMessages[userId] = colorToGo
                            messageOfColor = colorToGo
                        }
                    }
                }
                let position: BubblePosition = message.userId == self?.userId ? .right : .left
                return MessageCell(id: message.id, message: message.message, createdTime: message.createdTime, userId: message.userId, postId: message.postId, position: position, imageURL: message.imageURL,userName: message.userName, color: messageOfColor)
            })
            self.messagesCellList = [self.firstMessage]
            self.messagesCellList.append(contentsOf: messagesTemp)
            
        })
        
    }
    
    func sendMessage(_ messageContent: String, image: UIImage?) {
        let message = Message(message: messageContent, userId: userId, postId: post.id ?? "")
        messageRepository.addMessage(message, image: image)
    }
    
    func removePost() {
        let postId = post.id ?? ""
        postRepository.removePost(postId)
    }
}
