//
//  SearchDiaryViewModel.swift
//  Widi
//
//  Created by jeongminji on 6/5/25.
//

import SwiftUI
import Combine

/// 일기 검색 뷰모델
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
                Task {
                    await self.search(keyword: keyword)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func search(keyword: String) async {
        guard let uid = container.firebaseService.auth.currentUser?.uid else { return }
        
        do {
            let result = try await container.firebaseService.diary.searchDiaries(keyword: keyword, userId: uid)
            self.diaries = result
        } catch {
            print("❌ 검색 실패: \(error.localizedDescription)")
            self.diaries = []
        }
    }
    
    func deleteDiary(_ diary: DiaryResponse) async {
        do {
            try await container.firebaseService.diary.deleteDiary(documentId: diary.documentId)
            diaries.removeAll { $0.id == diary.id }
        } catch {
            print("일기 삭제 실패: \(error.localizedDescription)")
        }
    }
}
