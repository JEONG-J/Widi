//
//  DetailFriendsView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import SwiftUI

/// 친구 상세 뷰
struct DetailFriendsView: View {
    
    // MARK: - Properties
    
    @Bindable private var viewModel: DetailFriendsViewModel
    @EnvironmentObject var container: DIContainer
    
    @State private var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @State private var diariesOffsets: [UUID: CGFloat] = [:]
    @State private var isDropDownPresented: Bool = false
    @State private var targetDiary: DiaryResponse? = nil
    
    private let naviHeight: CGFloat = 59
    private let headerHeight: CGFloat = 209
    
    
    // MARK: - Init
    
    init(container: DIContainer, friendResponse: FriendResponse) {
        self.viewModel = .init(container: container, friendResponse: friendResponse)
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
        .navigationBarBackButtonHidden(true)
        .overlay(content: {
            if viewModel.showFriendDeleteAlert {
                CustomAlertView(content: {
                    CustomAlert(alertButtonType: .friendsDelete, onCancel: {
                        viewModel.showFriendDeleteAlert = false
                    }, onRight: {
                        Task {
                            await viewModel.deleteFriend()
                            viewModel.showFriendDeleteAlert = false
                            container.navigationRouter.pop()
                        }
                    })
                })
            }
        })
        .sheet(isPresented: $viewModel.showFriendEdit, content: {
            DetailFriendUpdateView(contaienr: container, showFriendEdit: $viewModel.showFriendEdit)
        })
        .overlay(content: {
            if viewModel.showDiaryDeleteAlert {
                CustomAlertView(content: {
                    CustomAlert(alertButtonType: .diaryDelete, onCancel: {
                        viewModel.showDiaryDeleteAlert = false
                    }, onRight: {
                        Task {
                            await viewModel.deleteDiaryAPI()
                            
                            if let diary = targetDiary {
                                await viewModel.deleteDiary(diary)
                                diariesOffsets[diary.id] = nil
                                viewModel.showDiaryDeleteAlert = false
                            }
                        }
                    })
                })
            }
        })
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
                    container.navigationRouter.pop()
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
    }
    
    /// 일기 추가 버튼
    var addButton: some View {
        VStack {
            Spacer()
            
            DiariesAddButton(
                action: {
                    container.navigationRouter.push(to: .addDiaryView(friendsRequest: viewModel.returnFriendInfo(), firstMode: false))
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
                    container.navigationRouter.push(to: .searchDiary)
                case .edit:
                    viewModel.showFriendEdit.toggle()
                case .delete:
                    withAnimation(.easeInOut) {
                        viewModel.showFriendDeleteAlert.toggle()
                    }
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
                HeaderView(friendData: viewModel.friendResponse, headerHeight: headerHeight)
                diarySection(topSafeArea: topSafeArea)
            }
        }
        .coordinateSpace(name: "SCROLL")
        .clipShape(
            UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
        )
        .disabled(viewModel.diaries?.isEmpty ?? true)
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
        .frame(minHeight: getScreenSize().height )
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
            if let diaries = viewModel.diaries {
                ForEach(Array(diaries.enumerated()), id: \.element.id) { index, diary in
                    
                    DiaryRowView(
                        diary: diary,
                        offset: Binding(
                            get: { diariesOffsets[diary.id] ?? 0 },
                            set: { diariesOffsets[diary.id] = $0 }
                        ),
                        allOffsets: $diariesOffsets,
                        deleteAction: {
                            withAnimation(.easeInOut) {
                                viewModel.showDiaryDeleteAlert.toggle()
                                self.targetDiary = diary
                            }
                        }
                    )
                    .frame(height: 171)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // TODO: - 일기 상세 화면 뷰
                    }
                    
                    if index < diaries.count - 1 {
                        Divider()
                            .background(Color.gray20)
                        
                    }
                }
                .offset(y: -48)
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
