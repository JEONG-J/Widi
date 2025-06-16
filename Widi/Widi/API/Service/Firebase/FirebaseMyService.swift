//
//  FirebaseMyService.swift
//  Widi
//
//  Created by Apple Coding machine on 6/15/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseMyService {
    private let db = Firestore.firestore()
    
    func fetchMyInfo() async throws -> UserResponse {
        guard let user = Auth.auth().currentUser else {
            throw FirebaseServiceError.custom(message: "로그인된 사용자가 없습니다.")
        }
        
        let docRef = db.collection("users").document(user.uid)
        let document = try await docRef.getDocument()
        
        guard document.exists else {
            throw FirebaseServiceError.documentNotFound
        }
        
        guard let userInfo = try? document.data(as: UserResponse.self) else {
            throw FirebaseServiceError.custom(message: "유저 정보를 디코딩할 수 없습니다.")
        }
        
        return userInfo
    }
    
    func updateToggle(to isOn: Bool) async throws {
        guard let user = Auth.auth().currentUser else {
            throw FirebaseServiceError.custom(message: "로그인된 사용자가 없습니다.")
        }
        
        let docRef = db.collection("users").document(user.uid)
        try await docRef.updateData([
            "toogle": isOn
        ])
    }
    
    func sendInquiry(email: String, message: String) async throws {
        let inquiry = InquiryRequest(email: email, message: message)
        let ref = db.collection("inquiries").document()
        
        do {
            try ref.setData(from: inquiry)
        } catch {
            throw FirebaseServiceError.custom(message: "문의 전송 실패: \(error.localizedDescription)")
        }
    }
}
