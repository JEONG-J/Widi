//
//  TestProtocol.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation

protocol ButtonTextProtocol {
    var deleteText: String { get }
    var cancelText: String { get }
    var withdraw: String { get }
    var delete: String { get }
}

extension ButtonTextProtocol {
    var deleteText: String { "삭제하기" }
    var cancelText: String { "돌아가기" }
    var withdraw: String { "탈퇴하기" }
    var delete: String { "삭제하기" }
}
