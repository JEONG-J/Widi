//
//  DetailDiaryViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation

/// 일기 상세 뷰모델
@Observable
class DetailDiaryViewModel: DiaryViewModelProtocol {
    
    var diary: DiaryResponse? = nil
    var diaryImages: [DiaryImage] = []
    
    var diaryMode: DiaryMode
    
    init(diaryMode: DiaryMode) {
        self.diaryMode = diaryMode
    }
}
