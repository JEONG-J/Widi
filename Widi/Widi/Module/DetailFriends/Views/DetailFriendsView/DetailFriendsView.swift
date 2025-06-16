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
    @State private var viewModel: DetailFriendsViewModel
    @EnvironmentObject var container: DIContainer
    
    @State private var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @State private var diariesOffsets: [UUID: CGFloat] = [:]
    
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
        .task {
            guard let documentId = viewModel.friendResponse.documentId else {
                print("documentId가 nil입니다. 친구 정보를 불러올 수 없습니다.")
                return
            }

            await viewModel.loadFriend(documentId: documentId)
            await viewModel.fetchDiaries(for: viewModel.friendResponse)
        }
        .loadingOverlay(
            isLoading: viewModel.deleteLoading,
            loadingType: .delete
        )
        .loadingOverlay(isLoading: viewModel.isFriendInfoLoading, loadingType: .diaryFriendInfo)
        .alertModifier(
            show: viewModel.showFriendDeleteAlert,
            content: {
                CustomAlert(alertButtonType: .friendsDelete, onCancel: {
                        viewModel.showDiaryDeleteAlert.toggle()
                }, onRight: {
                        Task {
                            viewModel.showFriendDeleteAlert.toggle()
                            await viewModel.deleteFriend()
                            container.navigationRouter.pop()
                        }
                })
            }
        )
        .alertModifier(
            show: viewModel.showDiaryDeleteAlert,
            content: {
                CustomAlert(alertButtonType: .diaryDelete, onCancel: {
                    viewModel.showDiaryDeleteAlert.toggle()
                }, onRight: {
                    Task {
                        guard let diary = viewModel.targetDiary else { return }
                        await viewModel.deleteDiary(diary)
                        diariesOffsets[diary.id] = nil
                        viewModel.showDiaryDeleteAlert.toggle()
                    }
                })
            }
        )
        .sheet(isPresented: $viewModel.showFriendEdit, onDismiss: {
            Task {
                guard let documentId = viewModel.friendResponse.documentId else {
                    print("documentId가 nil입니다. 친구 정보를 불러올 수 없습니다.")
                    return
                }
                await viewModel.loadFriend(documentId: documentId)
            }
        }, content: {
            DetailFriendUpdateView(container: container,
                                   showFriendEdit: $viewModel.showFriendEdit,
                                   friendResponse: viewModel.friendResponse)
        })
    }
    
    // MARK: - TopController
    
    /// 상단 네비게이션 바
    private var navigationBar: some View {
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
                        viewModel.isDropDownPresented.toggle()
                    }
                default:
                    break
                }
            }
        )
        .padding(.horizontal, UIConstants.defaultHorizontalPadding)
    }
    
    /// 일기 추가 버튼
    private var addButton: some View {
        VStack {
            Spacer()
            
            DiariesAddButton(
                action: {
                    container.navigationRouter.push(to: .addDiaryView(friendsRequest: viewModel.returnFriendInfo(), friendId: viewModel.friendResponse.friendId))
                }
            )
            .frame(width: DetailFriendsConstants.buttonWidth)
            .safeAreaPadding(.trailing, DetailFriendsConstants.addButtonTrailingPadding)
            .safeAreaPadding(.bottom, DetailFriendsConstants.addButtonBottomPadding)
        }
    }
    
    /// 일기 검색, 친구 수정, 친구 삭제 Menu
    @ViewBuilder
    var dropDownOverlay: some View {
        if viewModel.isDropDownPresented {
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.isDropDownPresented.toggle()
                    }
                }
            
            FriendDropDown(onSelect: { selected in
                switch selected {
                case .search:
                    container.navigationRouter.push(to: .searchDiary(friendResponse: viewModel.friendResponse))
                case .edit:
                    viewModel.showFriendEdit.toggle()
                case .delete:
                    withAnimation(.easeInOut) {
                        viewModel.showFriendDeleteAlert.toggle()
                    }
                }
            })
            .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
            .transition(.scale(scale: 0.7, anchor: .topTrailing).combined(with: .opacity))
        }
    }
    
    // MARK: - Diary BottomContents
    
    /// scrollContent
    /// - Parameter topSafeArea: geometry로 상단 SafeArea 값(diarySection 하위뷰에 전달하기 위해 필요)
    /// - Returns: 네비바 제외 content 스크롤 content로 반환
    func scrollContent(topSafeArea: CGFloat) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: .zero) {
                HeaderView(friendResponse: viewModel.friendResponse, headerHeight: DetailFriendsConstants.headerViewHeight)
                diarySection()
            }
        }
        .coordinateSpace(name: "SCROLL")
        .clipShape(
            UnevenRoundedRectangle(topLeadingRadius: DetailFriendsConstants.cornerRadius, topTrailingRadius: DetailFriendsConstants.cornerRadius)
        )
        .disabled(viewModel.diaries?.isEmpty ?? true)
    }
    
    /// diarySection
    /// - Returns: 아이템 갯수 상관없이 바닥까지 높이가지는 일기 세션 반환
    func diarySection() -> some View {
        VStack {
            if !viewModel.diaryInfoLoading {
                diaryContetns
            } else {
                progressView
            }
        }
        .frame(minHeight: getScreenSize().height )
        .background(Color.whiteBlack.opacity(0.8))
        .clipShape(
            UnevenRoundedRectangle(topLeadingRadius: DetailFriendsConstants.cornerRadius, topTrailingRadius: DetailFriendsConstants.cornerRadius)
        )
        .sheet()
    }
    
    /// 하단 다이어리 리스트 컨텐츠
    @ViewBuilder
    private var diaryContetns: some View {
        LazyVStack(
            alignment: .leading,
            spacing: .zero,
            pinnedViews: [.sectionHeaders]
        ) {
            Section {
                diaryList()
            } header: {
                pinnedHeaderView()
                    .modifier(OffsetModifier(offset: $headerOffsets.0, returnromStart: false))
                    .modifier(OffsetModifier(offset: $headerOffsets.1))
            }
        }
        
        Spacer()
            .frame(minHeight: 120)
    }
    
    /// 스티키 헤더 뷰, 일기 리스트 상단 그라데이션 뷰
    /// - Returns: 일기리스트 세션 헤더
    func pinnedHeaderView() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [.whiteBlack.opacity(0.7), .clear]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: DetailFriendsConstants.pinnedHeaderHeight)
    }
    
    /// 일기 리스트
    @ViewBuilder
    private func diaryList() -> some View {
        VStack(spacing: .zero) {
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
                                viewModel.targetDiary = diary
                            }
                        }
                    )
                    .frame(height: DetailFriendsConstants.diaryRowHeight)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        container.navigationRouter.push(to: .detailDiaryView(friendName: viewModel.friendResponse.name, diaryResponse: diary))
                    }
                    if index < diaries.count - 1 {
                        Divider()
                            .background(Color.gray20)
                        
                    }
                }
                .offset(y: DetailFriendsConstants.diaryListYOffset)
            }
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        Spacer().frame(height: DetailFriendsConstants.loadingSpacerHeight)
        
        HStack {
            Spacer()
            
            ProgressView()
                .controlSize(.large)
                .tint(Color.orange30)
            
            Spacer()
        }
        
        Spacer()
    }
}

fileprivate enum DetailFriendsConstants {
    // Layout Heights
    static let navigationBarHeight: CGFloat = 59
    static let headerViewHeight: CGFloat = 209
    static let diaryRowHeight: CGFloat = 171
    static let pinnedHeaderHeight: CGFloat = 36
    static let loadingSpacerHeight: CGFloat = 160
    static let bottomSpacerHeight: CGFloat = 120
    
    static let buttonWidth: CGFloat = 56
    
    // Button Padding
    static let addButtonTrailingPadding: CGFloat = 20
    static let addButtonBottomPadding: CGFloat = 12
    
    // Content Offset
    static let diaryListYOffset: CGFloat = -48
    
    // CornerRadius
    static let cornerRadius: CGFloat = 24
}
