//
//  SearchDiaryView.swift
//  Widi
//
//  Created by jeongminji on 6/5/25.
//

import SwiftUI

/// 일기 검색 뷰
struct SearchDiaryView: View {
    
    // MARK: - Property
    
    @State private var viewModel: SearchDiaryViewModel
    @EnvironmentObject var container: DIContainer
    @FocusState private var isTextFieldFocused: Bool
    
    // MARK: - Init
    /// SearchDiaryView
    /// - Parameter viewModel: SearchDiaryViewModel
    init(container: DIContainer, friendResponse: FriendResponse) {
        self.viewModel = .init(container: container, friendResponse: friendResponse)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: SearchDiaryConstants.sectionSpacing, content: {
                searchBar
                    .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
                
                diaryList
            })
            .background(.whiteBlack)
            .task {
                isTextFieldFocused = true
                UIApplication.shared.hideKeyboard()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    navigationBar
                })
            })
    }
    
    // MARK: - Subviews
    
    /// 상단 x 버튼
    var navigationBar: some View {
        Button {
            container.navigationRouter.pop()
        } label: {
            NavigationIcon.closeX.image
                .padding(NavigationIcon.closeX.paddingValue)
        }
    }
    
    /// 검색바
    @ViewBuilder
    var searchBar: some View {
        HStack(spacing: 8) {
            Image(.search)
                .resizable()
                .foregroundStyle(.gray50)
                .frame(width: SearchDiaryConstants.searchIconSize, height: SearchDiaryConstants.searchIconSize)
            
            TextField(
                "",
                text: $viewModel.searchText,
                prompt: Text(SearchDiaryConstants.textFieldPlaceholder)
                    .foregroundStyle(Color.gray30)
            )
            .font(.etc)
            .foregroundStyle(Color.gray80)
            .tint(Color.gray80)
            .focused($isTextFieldFocused)
            .submitLabel(.search)
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(.closeSmall)
                        .resizable()
                        .foregroundStyle(.gray30)
                        .frame(width: SearchDiaryConstants.closeIconSize, height: SearchDiaryConstants.closeIconSize)
                }
            }
        }
        .padding(.leading, SearchDiaryConstants.searchBarLeadingPadding)
        .padding(.trailing, SearchDiaryConstants.searchBarTrailingPadding)
        .padding(.vertical, SearchDiaryConstants.searchBarVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: SearchDiaryConstants.cornerRadius)
                .fill(Color.gray10)
        )
        .padding(.bottom, SearchDiaryConstants.searchBarBottomPadding)
    }
    
    /// 일기 리스트
    @ViewBuilder
    var diaryList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.diaries.enumerated()), id: \.element.id) { index, diary in
                    DiaryRowView(
                        diary: diary,
                        offset: Binding(
                            get: { viewModel.offsets[diary.id] ?? 0 },
                            set: { viewModel.offsets[diary.id] = $0 }
                        ),
                        allOffsets: $viewModel.offsets,
                        deleteAction: {
                            Task {
                                await viewModel.deleteDiary(diary)
                            }
                        }
                    )
                    .frame(height: SearchDiaryConstants.rowHeight)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        container.navigationRouter.push(to: .detailDiaryView(friendName: viewModel.friendResponse.name, diaryResponse: diary))
                    }
                    
                    if index < viewModel.diaries.count - 1 {
                        Divider()
                            .background(Color.gray20)
                    }
                }
            }
        }
    }
}

/// 검색 뷰 상수 Enum
fileprivate enum SearchDiaryConstants {
    // 텍스트
    static let textFieldPlaceholder = "검색어를 입력해주세요"

    // 패딩
    static let topSafeAreaPadding: CGFloat = 16
    static let searchBarLeadingPadding: CGFloat = 20
    static let searchBarTrailingPadding: CGFloat = 12
    static let searchBarVerticalPadding: CGFloat = 12
    static let searchBarBottomPadding: CGFloat = 4

    // 아이콘
    static let searchIconSize: CGFloat = 24
    static let closeIconSize: CGFloat = 20

    // 레이아웃
    static let sectionSpacing: CGFloat = 12
    static let rowHeight: CGFloat = 171
    static let cornerRadius: CGFloat = 24
}
