//
//  DiaryViewModelProtocol.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import Foundation

/// 다이어리 생성 및 조회 수정 공통 인터페이스
@Observable
protocol DiaryViewModelProtocol: ObservableObject {
    
    associatedtype DiaryData: DiaryDTO
    
    var diary: DiaryData? { get set }
    var diaryMode: DiaryMode { get }
    var diaryImages: [DiaryImage] { get set }
}
