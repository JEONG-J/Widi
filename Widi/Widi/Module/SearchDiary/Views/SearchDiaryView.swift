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
    
    @Bindable private var viewModel: SearchDiaryViewModel
    @EnvironmentObject var container: DIContainer
    
    @FocusState private var isTextFieldFocused: Bool
    
    // MARK: - Init
    
    /// SearchDiaryView
    /// - Parameter viewModel: SearchDiaryViewModel
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    
    var body: some View {
            VStack(spacing: 12) {
                navigationBar
                    .safeAreaPadding(.horizontal, 16)
                
                searchBar
                    .safeAreaPadding(.horizontal, 16)
                
                diaryList
            }
            .safeAreaPadding(.top, 16)
            .background(.whiteBlack)
            .task {
                isTextFieldFocused = true
                UIApplication.shared.hideKeyboard()
            }
            .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Subviews
    
    /// 상단 x 버튼
    @ViewBuilder
    var navigationBar: some View {
        HStack {
            Button {
                container.navigationRouter.pop()
            } label: {
                NavigationIcon.closeX.image
                    .padding(8)
            }
            Spacer()
        }
    }
    
    /// 검색바
    @ViewBuilder
    var searchBar: some View {
        HStack(spacing: 8) {
            Image(.search)
                .resizable()
                .foregroundStyle(.gray50)
                .frame(width: 24, height: 24)
            
            TextField(
                "",
                text: $viewModel.searchText,
                prompt: Text("검색어를 입력해주세요")
                    .foregroundStyle(Color.gray30)
            )
            .font(.etc)
            .foregroundStyle(Color.gray80)
            .tint(Color.gray80)
            .focused($isTextFieldFocused)
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(.closeSmall)
                        .resizable()
                        .foregroundStyle(.gray30)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.gray10)
        )
        .padding(.bottom, 4)
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
                            viewModel.deleteDiary(diary)
                        }
                    )
                    .frame(height: 171)
                    .contentShape(Rectangle())
                    .onTapGesture {
//                        container.navigationRouter.push(to: .detailDiaryView)
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


#Preview {
    SearchDiaryView(container: DIContainer())
}
