//
//  TaskRepository.swift
//  MakeItSo
//
//  Created by Peter Friese on 14/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
//import Disk

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions

import Combine
import Resolver
import CoreLocation
import UIKit

class BasePostRepository {
  @Published var posts: [Post]?
  @Published var locationService: LocationService = Resolver.resolve()
}

protocol PostRepository: BasePostRepository {
    
  func addPost(_ post: Post, image: UIImage?)
  func removePost(_ postId: String)
  func loadData()
}

class FirestorePostRepository: BasePostRepository, PostRepository, ObservableObject {
  @Injected var db: Firestore
  @Injected var authenticationService: AuthenticationService
  @LazyInjected var functions: Functions
  
  var postsPath: String = "posts"
  var userId: String = "unknown"
  
  private var cancellables = Set<AnyCancellable>()
  
  override init() {
    super.init()
    
    authenticationService.$user
      .compactMap { user in
        user?.uid
      }
      .assign(to: \.userId, on: self)
      .store(in: &cancellables)
    
    // (re)load data if user changes
    authenticationService.$user
      .receive(on: DispatchQueue.main)
      .sink { user in
        self.loadData()
      }
      .store(in: &cancellables)
  }
  
  func loadData() {
    db.collection(postsPath)
      .order(by: "createdTime",descending: true)
      .addSnapshotListener { querySnapshot, error in
        // 4
        if let error = error {
          print("Error getting cards: \(error.localizedDescription)")
          return
        }

        // 5
        let postss = querySnapshot?.documents.compactMap { document in
          // 6
          try? document.data(as: Post.self)
        } ?? []
          
          self.posts = postss.filter {[weak self] post in
              guard let myLocation = self?.locationService.lastLocation else {
                  guard let _ = post.latitude, let _ = post.longitude else {
                      return true
                  }
                  return false
              }
              
              guard let postItemLatitude = post.latitude, let postItemLongitude = post.longitude else {
                  return false
              }
              let coordinate = CLLocation(latitude: postItemLatitude, longitude: postItemLongitude)
              let distance = abs(myLocation.distance(from: coordinate))
              
              return distance < 5000
          }
      }
  }
  
    func addPost(_ post: Post, image: UIImage?) {
        
        var userPost = post
        uploadPhotoToFIRStorage(post, image: image) { url in
            do {
                if let urlStringOfImage = url {
                    userPost.image = urlStringOfImage
                }
                userPost.username = Auth.auth().currentUser?.displayName
                userPost.userId = self.userId
                let location = self.locationService.lastLocation?.coordinate
                userPost.latitude = location?.latitude
                userPost.longitude = location?.longitude
                let _ = try self.db.collection(self.postsPath).addDocument(from: userPost)
            }
            catch {
                fatalError("Unable to encode task: \(error.localizedDescription).")
            }
        }
        
    }
    
    
    private func uploadPhotoToFIRStorage(_ post: Post,image: UIImage?, handler:@escaping (_ url:String?)-> Void){
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
    
  func removePost(_ postId: String) {
      db.collection(postsPath).document(postId).delete { (error) in
        if let error = error {
          print("Unable to remove document: \(error.localizedDescription)")
        }
      }
  }
}
