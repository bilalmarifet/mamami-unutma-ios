//
//  TaskListViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 13/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine
import Resolver
import FirebaseAuth


enum StateOfView {
    case idle
    case loading
    case failed(Error)
    case loaded([Post])
}

class MainViewModel: ObservableObject {
    @Published var postRepository: PostRepository = Resolver.resolve()
    @Published var taskCellViewModels = [Post]()
    @Published private(set) var state = StateOfView.loading
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading = true
    init() {
        postRepository.$posts
            .sink(receiveValue: { value in
                if let value = value {
                    self.state = .loaded(value)
                    self.taskCellViewModels = value
                } else {
                    self.state = .failed(NSError())
                }
            })
            .store(in: &cancellables)
    }
    
    
    func loadData() {
        isLoading = true
        postRepository.loadData()
    }
    
}
