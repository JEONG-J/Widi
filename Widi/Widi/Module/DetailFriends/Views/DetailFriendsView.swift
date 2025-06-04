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
    @State private var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @State private var diariesOffsets: [UUID: CGFloat] = [:]
    @State private var isActionSheetPresented: Bool = false
    
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
                        isActionSheetPresented = true
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
            
            // TODO: - 일기 추가 화면 이동
            DiariesAddButton(action: {})
                .frame(width: 56)
                .padding(.trailing, 20)
                .padding(.bottom, 12)
        }
    }
    
    /// 일기 검색, 친구 수정, 친구 삭제 액션시트
    @ViewBuilder
    var dropDownOverlay: some View {
        if isActionSheetPresented {
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isActionSheetPresented = false
                    }
                }
            
            FriendDropDown(onSelect: { selected in
                switch selected {
                case .search:
                    // TODO: - 바텀시트 등장
                    print("검색")
                case .edit:
                    // TODO: - 네비게이션 연결
                    print("편집")
                case .delete:
                    // TODO: - 서버 호출 및 네비게이션 연결
                    print("삭제")
                }
            })
            .padding(.horizontal, 22)
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
            title: "학식당에서",
            content: "명상의 힘은 마음을 가라앉히고 내면의 평화를 찾는 방법을 제공합니다. 정기적인 명상은 스트레스를 줄이고 집중력을 향상시키는 방법입니다.",
            pictures:  ["https://i.namu.wiki/i/4HF0qDNbaYaUTHCyJJTMPJ9ADmbXdc4C6ahEqIxURdzOeBZqIxzY69Xu9EbP3qlX-kCCunsBwAZpSvccoHLiFGcdpbHaeBz2QpFDzVrAoc6PFvj_ieSeVQwvn-gMKveZAj-EtVaxqdf7G6Q2zSXDnw.webp"],
            diaryDate: "2025 / 05 / 24"
        ),
        DiaryResponse(
            id: UUID(),
            title: "학식당에서",
            content: "명상의 힘은 마음을 가라앉히고 내면의 평화를 찾는 방법을 제공합니다. 정기적인 명상은 스트레스를 줄이고 집중력을 향상시키는 방법입니다.",
            pictures:  ["https://i.namu.wiki/i/4HF0qDNbaYaUTHCyJJTMPJ9ADmbXdc4C6ahEqIxURdzOeBZqIxzY69Xu9EbP3qlX-kCCunsBwAZpSvccoHLiFGcdpbHaeBz2QpFDzVrAoc6PFvj_ieSeVQwvn-gMKveZAj-EtVaxqdf7G6Q2zSXDnw.webp"],
            diaryDate: "2025 / 05 / 24"
        ),
        DiaryResponse(
            id: UUID(),
            title: "학식당에서",
            content: "명상의 힘은 마음을 가라앉히고 내면의 평화를 찾는 방법을 제공합니다. 정기적인 명상은 스트레스를 줄이고 집중력을 향상시키는 방법입니다.",
            pictures:  ["https://i.namu.wiki/i/4HF0qDNbaYaUTHCyJJTMPJ9ADmbXdc4C6ahEqIxURdzOeBZqIxzY69Xu9EbP3qlX-kCCunsBwAZpSvccoHLiFGcdpbHaeBz2QpFDzVrAoc6PFvj_ieSeVQwvn-gMKveZAj-EtVaxqdf7G6Q2zSXDnw.webp"],
            diaryDate: "2025 / 05 / 24"
        ),
        DiaryResponse(
            id: UUID(),
            title: "학식당에서",
            content: "명상의 힘은 마음을 가라앉히고 내면의 평화를 찾는 방법을 제공합니다. 정기적인 명상은 스트레스를 줄이고 집중력을 향상시키는 방법입니다.",
            pictures:  ["https://i.namu.wiki/i/4HF0qDNbaYaUTHCyJJTMPJ9ADmbXdc4C6ahEqIxURdzOeBZqIxzY69Xu9EbP3qlX-kCCunsBwAZpSvccoHLiFGcdpbHaeBz2QpFDzVrAoc6PFvj_ieSeVQwvn-gMKveZAj-EtVaxqdf7G6Q2zSXDnw.webp"],
            diaryDate: "2025 / 05 / 24"
        ),
        DiaryResponse(
            id: UUID(),
            title: "학식당에서",
            content: "명상의 힘은 마음을 가라앉히고 내면의 평화를 찾는 방법을 제공합니다. 정기적인 명상은 스트레스를 줄이고 집중력을 향상시키는 방법입니다.",
            pictures:  ["https://i.namu.wiki/i/4HF0qDNbaYaUTHCyJJTMPJ9ADmbXdc4C6ahEqIxURdzOeBZqIxzY69Xu9EbP3qlX-kCCunsBwAZpSvccoHLiFGcdpbHaeBz2QpFDzVrAoc6PFvj_ieSeVQwvn-gMKveZAj-EtVaxqdf7G6Q2zSXDnw.webp"],
            diaryDate: "2025 / 05 / 24"
        )
    ]
    
    let viewModel = DetailFriendsViewModel(friendData: dummyFriend, diaries: dummyDiaries)
    DetailFriendsView(viewModel: viewModel)
}
