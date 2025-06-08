//
//  DetailDiaryViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation

class DetailDiaryViewModel: DiaryViewModelProtocol {
    
    @Published var diary: DiaryResponse? = nil
    @Published var diaryImages: [DiaryImage] = []
    
    var diaryMode: DiaryMode
    
    init(diaryMode: DiaryMode) {
        self.diaryMode = diaryMode
    }
}
