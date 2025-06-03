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
            actionSheetOverlay
        }
        .background(FriendDetailBackground())
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
                    withAnimation {
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
    var actionSheetOverlay: some View {
        if isActionSheetPresented {
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
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
                    PinnedHeaderView()
                        .modifier(OffsetModifier(offset: $headerOffsets.0, returnromStart: false))
                        .modifier(OffsetModifier(offset: $headerOffsets.1))
                }
            }
            
            Spacer()
        }
        .frame(minHeight: UIScreen.main.bounds.height - topSafeArea - naviHeight - headerHeight)
        .background(Color.whiteBlack.opacity(0.8))
        .clipShape(
            UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
        )
        .sheet()
    }
    
    /// 일기 리스트
    var diaryList: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.diaries.enumerated()), id: \.element.id) { index, diary in
                DiaryRowView(
                    diary: diary,
                    index: index,
                    totalCount: viewModel.diaries.count,
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
            }
        }
        .offset(y: -48)
    }
}

/// DiaryPreviewCard에 Divider  긋고, DeleteButtonView랑 중첩한 일기 카드
fileprivate struct DiaryRowView: View {
    let diary: DiaryResponse
    let index: Int
    let totalCount: Int
    @Binding var offset: CGFloat
    @Binding var allOffsets: [UUID: CGFloat]
    let deleteAction: () -> Void
    private let deleteButtonWidth: CGFloat = 68
    
    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 0) {
                DiaryPreviewCard(diaryData: diary)
                    .frame(height: 171)
                    .offset(x: offset)
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                handleDragChanged(value)
                            }
                            .onEnded { value in
                                handleDragEnded(value)
                            }
                    )
                
                if index < totalCount - 1 {
                    Divider()
                        .background(Color.gray20)
                }
            }
            
            if abs(offset) > 30 {
                DeleteButtonView {
                    deleteAction()
                }
            }
        }
        .animation(.easeInOut, value: offset)
    }
    
    /// 드래그 중 액션, 드래그 범위 제한
    /// - Parameter value: 드래그 값
    private func handleDragChanged(_ value: DragGesture.Value) {
        if abs(value.translation.width) > abs(value.translation.height) {
            if value.translation.width < 0 {
                closeOtherCards(except: diary.id)
                offset = max(value.translation.width, -deleteButtonWidth)
            } else {
                offset = 0
            }
        }
    }
    
    /// 드래그 멈춘 후 액션, 드래그 값 기반으로 삭제 버튼 열릴지, 닫힐 지 결정
    /// - Parameter value: 드래그 값
    private func handleDragEnded(_ value: DragGesture.Value) {
        if abs(value.translation.width) > abs(value.translation.height) {
            withAnimation {
                if value.translation.width < -deleteButtonWidth / 2 {
                    offset = -deleteButtonWidth
                } else {
                    offset = 0
                }
            }
        }
    }
    
    /// 일기 카드가 열릴때, 열려있는 다른 카드 닫히게 함
    /// - Parameter id: 현재 드래그 중인 일기 카드 id
    private func closeOtherCards(except id: UUID) {
        for key in allOffsets.keys {
            if key != id {
                allOffsets[key] = 0
            }
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

/// 스티키 헤더 뷰, 일기 리스트 상단 그라데이션 뷰
fileprivate struct PinnedHeaderView: View {
    var body: some View {
        HStack {
            LinearGradient(
                gradient: Gradient(colors: [.whiteBlack.opacity(1.0), .clear]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .frame(height: 48)
    }
}

/// 삭제 버튼 뷰
fileprivate struct DeleteButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Image(.delete)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 68)
        .frame(maxHeight: .infinity)
        .background(Color.red30)
        .transition(.move(edge: .trailing))
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
