//
//  TestProtocol.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation

protocol ButtonTextProtocol {
    var delete: String { get }
    var cancel: String { get }
    var withdraw: String { get }
    var logout: String { get }
}

extension ButtonTextProtocol {
    var delete: String { "삭제하기" }
    var cancel: String { "돌아가기" }
    var withdraw: String { "탈퇴하기" }
    var logout: String { "로그아웃" }
}
