//
//  DiaryViewModelProtocol.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import Foundation
import SwiftUI
import PhotosUI

/// 다이어리 생성 및 조회 수정 공통 인터페이스
protocol DiaryViewModelProtocol {
    
    associatedtype DiaryData: DiaryDTO
    
    var diary: DiaryData? { get set }
    var diaryImages: [DiaryImage] { get set }
    var selectedImage: DiaryImage? { get set }
    var photoImages: [PhotosPickerItem] { get set }
}
