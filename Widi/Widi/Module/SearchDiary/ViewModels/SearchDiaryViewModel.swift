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
    
    private var allDiaries: [DiaryResponse]
    private var cancellables = Set<AnyCancellable>()
    private let searchSubject = PassthroughSubject<String, Never>()
    
    var offsets: [UUID: CGFloat] = [:]
    
    // MARK: - Init
    
    /// SearchDiaryViewModel
    /// - Parameter diaries: 전체 다이어리 리스트
    init(diaries: [DiaryResponse]) {
        self.allDiaries = diaries
        setupSearch()
    }
    
    // MARK: - Methods
    
    private func setupSearch() {
        searchSubject
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] keyword in
                guard let self else { return }
                self.filterDiaries(with: keyword)
            }
            .store(in: &cancellables)
    }
    
    private func filterDiaries(with keyword: String) {
        
        diaries = allDiaries.filter {
            $0.title?.localizedCaseInsensitiveContains(keyword) ?? false ||
            $0.content.localizedCaseInsensitiveContains(keyword)
        }
    }
    
    func deleteDiary(_ diary: DiaryResponse) {
        diaries.removeAll { $0.id == diary.id }
    }
}
