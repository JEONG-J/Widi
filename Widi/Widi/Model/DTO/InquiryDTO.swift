//
//  InquiryRequest.swift
//  Widi
//
//  Created by Apple Coding machine on 6/15/25.
//

import Foundation
import FirebaseFirestore

/// 문의 내용 요청 모델
struct InquiryRequest: Codable {
    let email: String
    let message: String
    @ServerTimestamp var createdAt: Timestamp? = nil
}
