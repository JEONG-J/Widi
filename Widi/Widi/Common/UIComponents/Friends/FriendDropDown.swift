//
//  FirendsDropDown.swift
//  Widi
//
//  Created by Apple Coding machine on 6/3/25.
//

import SwiftUI

/// FriendDetailView의 드롭다운 컴포넌트
struct FriendDropDown: View {
    // MARK: - Property
    
    let onSelect: (DropDownMenu) -> Void
    
    
    // MARK: - Init
    init(onSelect: @escaping (DropDownMenu) -> Void) {
        self.onSelect = onSelect
    }
 
    var body: some View {
        VStack(alignment: .leading, content: {
            ForEach(Array(DropDownMenu.allCases.enumerated()), id: \.element) { index, menu in
                Button(action: {
                    onSelect(menu)
                }, label: {
                    Text(menu.text)
                        .font(menu.textFont)
                        .foregroundStyle(menu.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                        .padding(.leading, 16)
                        .padding(.trailing, 24)
                })
                
                if index < DropDownMenu.allCases.count - 1 {
                    Divider()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundStyle(Color.gray20)
                }
            }
        })
        .frame(width: 200, height: 160)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.whiteBlack)
                .shadow1()
        }
        .zIndex(1)
    }
}


#Preview() {
    FriendDropDown(onSelect: { selected in
        switch selected {
        case .search:
            print("검색")
        case .edit:
            print("편집")
        case .delete:
            print("삭제")
        }
    })
}
