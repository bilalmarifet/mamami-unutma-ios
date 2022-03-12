

import Foundation
import Combine
import Resolver
import UIKit

class AddPostViewModel: ObservableObject {
  @Published var postRepository: PostRepository = Resolver.resolve()
  
//  @Published var taskCellViewModels = [TaskCellViewModel]()
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
//    taskRepository.$tasks.map { tasks in
//      tasks.map { task in
//        TaskCellViewModel(task: task)
//      }
//    }
//    .assign(to: \.taskCellViewModels, on: self)
//    .store(in: &cancellables)
  }
    func addTask(post: Post, image: UIImage?) {
      postRepository.addPost(post,image: image)
  }
}
