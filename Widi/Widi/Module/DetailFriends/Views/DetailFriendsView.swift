//
//  DetailFriendsView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import SwiftUI

struct DetailFriendsView: View {
    
    // MARK: - Properties
    
    @Bindable private var viewModel: DetailFriendsViewModel
    
    @EnvironmentObject var container: DIContainer
    @State private var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @State private var diariesOffsets: [UUID: CGFloat] = [:]
    @State private var isDropDownPresented: Bool = false
    
    private let naviHeight: CGFloat = 56
    private let headerHeight: CGFloat = 209
    
    
    // MARK: - Init
    
    /// DetailFriendsView
    /// - Parameter viewModel: DetailFriendsViewModel
    init(viewModel: DetailFriendsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GeometryReader { geometry in
                VStack {
                    navigationBar
                    scrollContent(topSafeArea: geometry.safeAreaInsets.top)
                }
                .ignoresSafeArea(edges: .bottom)
            }
            addButton
            dropDownOverlay
        }
        .detailFriendViewBG()
    }
}

// MARK: - Subviews

fileprivate extension DetailFriendsView {
    /// 커스텀네비게이션 바
    var navigationBar: some View {
        CustomNavigation(
            config: .backAndContextMenu,
            leftAction: { icon in
                switch icon {
                case .backArrow:
                    // TODO: - 네비게이션 연결
                    print("뒤로가기")
                default:
                    break
                }
            },
            rightAction: { icon in
                switch icon {
                case .contextMenu:
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isDropDownPresented = true
                    }
                default:
                    break
                }
            }
        )
        .padding(.horizontal, 16)
        .frame(height: naviHeight)
    }
    
    /// 일기 추가 버튼
    var addButton: some View {
        VStack {
            Spacer()
            
            DiariesAddButton(
                action: {
                    container.navigationRouter.push(to: .addDiaryView)
                }
            )
            .frame(width: 56)
            .safeAreaPadding(.trailing, 20)
            .safeAreaPadding(.bottom, 12)
        }
    }
    
    /// 일기 검색, 친구 수정, 친구 삭제 액션시트
    @ViewBuilder
    var dropDownOverlay: some View {
        if isDropDownPresented {
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isDropDownPresented = false
                    }
                }
            
            FriendDropDown(onSelect: { selected in
                switch selected {
                case .search:
                    // TODO: - 일기 검색화면 네비 연결
                    withAnimation {
                        isDropDownPresented = false
                    }
                case .edit:
                    // TODO: - 네비게이션 연결
                    print("편집")
                case .delete:
                    // TODO: - 서버 호출 및 네비게이션 연결
                    print("삭제")
                }
            })
            .safeAreaPadding(.horizontal, 16)
            .transition(.scale(scale: 0.7, anchor: .topTrailing).combined(with: .opacity))
        }
    }
    
    /// scrollContent
    /// - Parameter topSafeArea: geometry로 상단 SafeArea 값(diarySection 하위뷰에 전달하기 위해 필요)
    /// - Returns: 네비바 제외 content 스크롤 content로 반환
    func scrollContent(topSafeArea: CGFloat) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderView(friendData: viewModel.friendData, headerHeight: headerHeight)
                diarySection(topSafeArea: topSafeArea)
            }
        }
        .coordinateSpace(name: "SCROLL")
        .clipShape(
            UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
        )
    }
    
    /// diarySection
    /// - Parameter topSafeArea: geometry로 상단 SafeArea 값
    /// - Returns: 아이템 갯수 상관없이 바닥까지 높이가지는 일기 세션 반환
    func diarySection(topSafeArea: CGFloat) -> some View {
        VStack {
            LazyVStack(
                alignment: .leading,
                spacing: 0,
                pinnedViews: [.sectionHeaders]
            ) {
                Section {
                    diaryList
                } header: {
                    pinnedHeaderView()
                        .modifier(OffsetModifier(offset: $headerOffsets.0, returnromStart: false))
                        .modifier(OffsetModifier(offset: $headerOffsets.1))
                }
            }
            
            Spacer()
                .frame(minHeight: 120)
        }
        .frame(minHeight: UIScreen.main.bounds.height - topSafeArea - naviHeight - headerHeight)
        .background(Color.whiteBlack.opacity(0.8))
        .clipShape(
            UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
        )
        .sheet()
    }
    
    /// 스티키 헤더 뷰, 일기 리스트 상단 그라데이션 뷰
    /// - Returns: 일기리스트 세션 헤더
    func pinnedHeaderView() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [.whiteBlack.opacity(0.7), .clear]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 36)
    }
    
    /// 일기 리스트
    var diaryList: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.diaries.enumerated()), id: \.element.id) { index, diary in
                
                DiaryRowView(
                    diary: diary,
                    offset: Binding(
                        get: { diariesOffsets[diary.id] ?? 0 },
                        set: { diariesOffsets[diary.id] = $0 }
                    ),
                    allOffsets: $diariesOffsets,
                    deleteAction: {
                        viewModel.deleteDiary(diary)
                        diariesOffsets[diary.id] = nil
                    }
                )
                .frame(height: 171)
                .contentShape(Rectangle())
                .onTapGesture {
                    container.navigationRouter.push(to: .detailDiaryView)
                }
                
                if index < viewModel.diaries.count - 1 {
                    Divider()
                        .background(Color.gray20)
                    
                }
            }
            .offset(y: -48)
        }
    }
}

/// 스크롤 시 사라지는 뷰, 친구 정보 뷰
fileprivate struct HeaderView: View {
    let friendData: FriendResponse
    let headerHeight: CGFloat
    
    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = max(0, size.height + minY)
            let threshhold = -(getScreenSize().height * 0.05)
            
            VStack(alignment: .leading, spacing: 32) {
                HStack(alignment: .center, spacing: 12) {
                    Text(friendData.name)
                        .font(.h1)
                        .foregroundStyle(.gray80)
                    
                    CustomProfileImage(
                        imageURLString: friendData.experienceDTO.characterInfo?.imageURL,
                        size: 40
                    )
                }
                
                FriendInfoView(friendInfoData: friendData)
                    .frame(maxWidth: .infinity)
                    .frame(height: 101)
                    .opacity(threshhold > minY ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: threshhold > minY)
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
            .frame(width: size.width, height: height)
            .offset(y: -minY)
        }
        .frame(height: headerHeight)
    }
}

#Preview {
    @Previewable @State var dummyFriend: FriendResponse = FriendResponse(name: "지나", birthDay: "04/20", experienceDTO: .init(experiencePoint: 3, characterInfo: .init(imageURL: "https://i.namu.wiki/i/w3zCJtF4bwby7ks27ujKimbyqA13XB7o4PrBY7FOnNvZbFEw9fwnx3TKxcFLiZboKGrwihJlk3feyQTBCyuYMg.webp")))
    
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
    
    let viewModel = DetailFriendsViewModel(friendData: dummyFriend, diaries: dummyDiaries)
    
    DetailFriendsView(viewModel: viewModel)
        .environmentObject(DIContainer())
}
