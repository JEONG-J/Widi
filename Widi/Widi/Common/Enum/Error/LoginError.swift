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
