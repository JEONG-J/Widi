//
//  CreateDiaryViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import Foundation

class CreateDiaryViewModel: DiaryViewModelProtocol {
    
    @Published var diary: DiaryRequest? = nil
    var diaryImages: [DiaryImage] = []
    
    var diaryMode: DiaryMode = .write
}
