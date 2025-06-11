//
//  ErrorMessage.swift
//  Widi
//
//  Created by Apple Coding machine on 6/9/25.
//

import Foundation

/// 로그인 에러 열거형
enum LoginError: LocalizedError {
    case invalidAppleCredential
    case invalidIdentityToken
    case firebaseSignInFailed(String)
    case unknownError
    case appleLoginFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidAppleCredential:
            return "Apple 로그인 인증 정보를 가져올 수 없습니다."
        case .invalidIdentityToken:
            return "Apple 토큰이 유효하지 않습니다."
        case .firebaseSignInFailed(let message):
            return "Firebase 로그인에 실패했습니다: \(message)"
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        case .appleLoginFailed(let error):
            return "Apple 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"
        }
    }
}

enum FirebaseServiceError: LocalizedError {
    case networkFailure
    case decodingFailed
    case documentNotFound
    case permissionDenied
    case unknownError
    case custom(message: String)

    var errorDescription: String? {
        switch self {
        case .networkFailure:
            return "네트워크 오류로 Firebase에 연결할 수 없습니다."
        case .decodingFailed:
            return "Firebase에서 받은 데이터를 해석할 수 없습니다."
        case .documentNotFound:
            return "요청한 문서를 찾을 수 없습니다."
        case .permissionDenied:
            return "해당 작업을 수행할 권한이 없습니다."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        case .custom(let message):
            return "Firebase 에러: \(message)"
        }
    }
}
