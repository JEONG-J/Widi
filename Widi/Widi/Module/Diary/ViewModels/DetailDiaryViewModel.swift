//
//  DetailDiaryViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation

@Observable
class DetailDiaryViewModel: DiaryViewModelProtocol {
    
    var diary: DiaryResponse? = nil
    var diaryImages: [DiaryImage] = []
    
    var diaryMode: DiaryMode
    
    init(diaryMode: DiaryMode) {
        self.diaryMode = diaryMode
    }
}
