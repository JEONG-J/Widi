//
//  SearchDiaryViewModel.swift
//  Widi
//
//  Created by jeongminji on 6/5/25.
//

import SwiftUI
import Combine

@Observable
class SearchDiaryViewModel {
    
    // MARK: - Properties
    
    var searchText: String = "" {
        didSet {
            searchSubject.send(searchText)
        }
    }
    var diaries: [DiaryResponse] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let searchSubject = PassthroughSubject<String, Never>()
    private var container: DIContainer
    
    var offsets: [UUID: CGFloat] = [:]
    
    let friendResponse: FriendResponse
    
    // MARK: - Init
    
    /// SearchDiaryViewModel
    /// - Parameter diaries: 전체 다이어리 리스트
    init(container: DIContainer, friendResponse: FriendResponse) {
        self.container = container
        self.friendResponse = friendResponse
        setupSearch()
    }
    
    // MARK: - Methods
    
    private func setupSearch() {
        searchSubject
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] keyword in
                guard let self else { return }
                self.self.searchServer()
            }
            .store(in: &cancellables)
    }
    
    func searchServer() {
        print("hello")
    }
    
    func deleteDiary(_ diary: DiaryResponse) {
        diaries.removeAll { $0.id == diary.id }
    }
}
