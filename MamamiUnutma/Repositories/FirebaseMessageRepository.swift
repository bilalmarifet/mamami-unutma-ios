
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions

import Combine
import Resolver
import SwiftUI
class BaseMessageRepository {
  @Published var messages = [Message]()
}

protocol MessageRepository: BaseMessageRepository {
    func addMessage(_ Message: Message, image: UIImage?)
func loadData(postId: String, completion: @escaping ([Message]) -> Void)
//  func removeMessage(_ Message: Message)
}

class FirestoreMessageRepository: BaseMessageRepository, MessageRepository, ObservableObject {
  @Injected var db: Firestore
  @Injected var authenticationService: AuthenticationService
  @LazyInjected var functions: Functions
  
  var messagesPath: String = "messages"
  var userId: String = "unknown"
//  @Published var postId: String
  private var cancellables = Set<AnyCancellable>()
  
  override init() {
    super.init()
    
    authenticationService.$user
      .compactMap { user in
        user?.uid
      }
      .assign(to: \.userId, on: self)
      .store(in: &cancellables)
      
//      $postId.receive(on: DispatchQueue.main)
//          .sink { value in
//              self.loadData(postId: value)
//          }
//
  }
  
    internal func loadData(postId: String, completion: @escaping ([Message]) -> Void) {
        db.collection(messagesPath).document(postId).collection("messages")
      .order(by: "createdTime")
      .addSnapshotListener { querySnapshot, error in
        // 4
        if let error = error {
          print("Error getting cards: \(error.localizedDescription)")
          return
        }

        // 5
        let messages = querySnapshot?.documents.compactMap { document in
          // 6
          try? document.data(as: Message.self)
        } ?? []
          completion(messages)
      }
  }
  
    func addMessage(_ message: Message, image: UIImage?) {
    do {
      var userMessage = message
        userMessage.userId = self.userId
        userMessage.userName = Auth.auth().currentUser?.displayName
        uploadPhotoToFIRStorage(message, image: image) { url in
            do {
                if let urlStringOfImage = url {
                    userMessage.imageURL = urlStringOfImage
                }
                let _ = try self.db.collection(self.messagesPath).document(message.postId).collection("messages").addDocument(from: userMessage)
            }
            catch {
                fatalError("Unable to encode task: \(error.localizedDescription).")
            }
        }
    }
  }
    
    
    
    private func uploadPhotoToFIRStorage(_ message: Message,image: UIImage?, handler:@escaping (_ url:String?)-> Void){
        guard let image = image else { return handler(nil) }
        let filePath = "\(Auth.auth().currentUser!.uid)/\(UUID())"
        let metaData = StorageMetadata()
        
        let data = image.jpegData(compressionQuality: 0.5)!
        metaData.contentType = "image/jpg"
        let storageRef = Storage.storage().reference()
        storageRef.child(filePath)
            .putData(data, metadata: metaData) { (metaData, error) in
                if let error = error {
                    print("error", error.localizedDescription)
                    handler(nil)
                }
                else {
                    storageRef.child(filePath)
                        .downloadURL { url, error in
                            if let error = error {
                                print(error)
                                handler(nil)
                            }
                            else {
                                handler(url?.absoluteString)
                            }
                        }
                }
            }
    }
    
    
  
//  func removeMessage(_ message: Message) {
//    if let messageID = message.id {
//      db.collection(messagesPath).document(MessageID).delete { (error) in
//        if let error = error {
//          print("Unable to remove document: \(error.localizedDescription)")
//        }
//      }
//    }
//  }
}
