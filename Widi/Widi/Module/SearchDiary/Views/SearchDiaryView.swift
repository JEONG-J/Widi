//
//  SearchDiaryView.swift
//  Widi
//
//  Created by jeongminji on 6/5/25.
//

import SwiftUI

struct SearchDiaryView: View {
    
    // MARK: - Property
    
    @Bindable private var viewModel: SearchDiaryViewModel
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var container: DIContainer
    @FocusState private var isTextFieldFocused: Bool
    @State private var moveNavi: Bool = false
    
    // MARK: - Init
    
    /// SearchDiaryView
    /// - Parameter viewModel: SearchDiaryViewModel
    init(viewModel: SearchDiaryViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
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
            .navigationDestination(isPresented: $moveNavi, destination: {
                DetailDiaryView()
            })
        }
    }
    
    // MARK: - Subviews
    
    /// 상단 x 버튼
    @ViewBuilder
    var navigationBar: some View {
        HStack {
            Button {
                dismiss()
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
//                        dismiss() // TODO: - 자니와 루카 얘기하기
//                        container.navigationRouter.push(to: .detailDiaryView)
                        
                        moveNavi.toggle()
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
    @Previewable @State var dummyDiaries: [DiaryResponse] = [
        DiaryResponse(
            id: UUID(),
            title: "여름 바다",
            content: "뜨거운 여름날, 시원한 바다를 바라보며 친구들과 놀았다. 바람이 기분 좋았다.",
            pictures: ["https://pimg.mk.co.kr/news/cms/202403/29/20240329_01110601000001_L01.jpg", "https://pimg.mk.co.kr/news/cms/202403/29/20240329_01110601000001_L01.jpg"],
            diaryDate: "2025 / 06 / 01"
        ),
        DiaryResponse(
            id: UUID(),
            content: "노랗게 물든 단풍길을 걷다 보니 가을이 깊어감을 느꼈다. 사진도 많이 찍었다.",
            pictures: [],
            diaryDate: "2025 / 01 / 15"
        ),
        DiaryResponse(
            id: UUID(),
            content: "도서관에서 하루 종일 책을 읽었다. 오랜만에 조용한 시간을 보냈다.",
            pictures: ["https://mblogthumb-phinf.pstatic.net/MjAyNDA4MDRfMjI5/MDAxNzIyNzU1NDE0MTQ5.gevr23_H7cZd_TFFvMwxxxknSY64mOvjRsBbNjwSopsg.57UoK7G4ioWfjIuEYDBQ0qmYnwd-hbBfETbTa13Y8tcg.JPEG/20230801%EF%BC%BF092949.jpg?type=w800"],
            diaryDate: "2025 / 02 / 20"
        ),
        DiaryResponse(
            id: UUID(),
            title: "친구와 영화",
            content: "친구와 최신 영화를 봤다. 재미있고 감동적인 장면이 많았다.",
            pictures: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS59y8lxcgT1bpo-UFhKxUUp7hT8z7PUWr97A&s"],
            diaryDate: "2025 / 03 / 12"
        ),
        DiaryResponse(
            id: UUID(),
            title: "봄꽃 축제",
            content: "만개한 봄꽃들을 구경하러 갔다. 형형색색 꽃들이 아름다웠다.",
            pictures: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQac9U1pW4QDEPBuVcBJTAEuPTQ-diXo5vEC6dsv6M-sUN_9srqggXHax2itKHC26IkKc8&usqp=CAU"],
            diaryDate: "2025 / 10 / 05"
        ),
        DiaryResponse(
            id: UUID(),
            title: "비 오는 날",
            content: "창밖으로 내리는 비를 바라보며 따뜻한 커피를 마셨다. 잔잔한 하루였다.",
            pictures: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv2znysM8hscNWLP8pdjV0iEG_Nd7sox20DvoaPmV68a4iN8XWnbvqpqvIyxO0MkLeouA&usqp=CAU"],
            diaryDate: "2025 / 04 / 18"
        ),
        DiaryResponse(
            title: "겨울 산책",
            content: "눈이 소복이 쌓인 길을 따라 조용히 산책을 했다. 고요하고 평화로운 느낌이었다.",
            pictures: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8oKFPctzGt7mCmM06q7Qp8qM0dO3S9LjHruBsuvAtprnmBxeAXYZymZKp84qVxD1puLc&usqp=CAU"],
            diaryDate: "2025 / 04 / 10"
        )
    ]
    
    let viewModel = SearchDiaryViewModel(diaries: dummyDiaries)
    
    SearchDiaryView(viewModel: viewModel)
        .environmentObject(DIContainer())
}
