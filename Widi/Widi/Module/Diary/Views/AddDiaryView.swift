//
//  AddDiaryView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import SwiftUI
import PhotosUI

/// 다이어리 생성 뷰
struct AddDiaryView: View {
    
    // MARK: - Property
    @State var viewModel: CreateDiaryViewModel
    @EnvironmentObject var container: DIContainer
    @FocusState var isFocused: Bool
    let friendId: String?
    
    // MARK: - Constants
    fileprivate enum AddDiaryViewConstants {
        // ETC
        static let sheetCornerRadius: CGFloat = 24
        static let maxSelectionCount: Int = 5
        
        // Bottom 텍스트필드
        static let bottomContentsSpacing: CGFloat = 28
        static let bottomTextFieldSpacing: CGFloat = 10
        static let lineSpacing: CGFloat = 1.6
        
        // 텍스트 필드 placeholder
        static let titlePlaceholder: String = "제목"
        static let contentsPlaceholder: String = "친구와의 추억을 적어주세요"
    }
    
    // MARK: - Init
    /// 일기 추가 뷰 초기화
    /// - Parameters:
    ///   - friendsRequest: 친구 정보
    ///   - friendId: 친구 아이디 없으면 처음 생성, 친구 아이디 값 넣으면 처음 생성 아님
    ///   - container: 뷰모델 사용 container
    init(
        friendsRequest: FriendRequest,
        friendId: String? = nil,
        container: DIContainer
    ) {
        self.viewModel = .init(friendRequest: friendsRequest, container: container)
        self.friendId = friendId
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.clear
                .writeDiaryViewBG()
            
            DiaryContainerView(imageScroll: {
                if !viewModel.diaryImages.isEmpty {
                    DiaryImageScrollView(images: viewModel.diaryImages, mode: .write,
                                         onDelete: { index in
                        removeAction(index)
                    }, onSelect: { image in
                        viewModel.selectedImage = image
                    })
                }
            }, content: {
                bottomContents
            })
        }
        .onChange(of: viewModel.photoImages, { oldValue, newValue in
            Task {
                await viewModel.convertSelectedPhotosToUIImage()
            }
        })
        .task {
            viewModel.dateString = ConvertDataFormat.shared.simpleDateString(from: .now)
            UIApplication.shared.hideKeyboard()
        }
        .onTapGesture {
            isFocused.toggle()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading, content: {
                CustomNavigationIcon(navigationIcon: .backArrow, action: {
                    withAnimation(.easeInOut) {
                        viewModel.checkBackView.toggle()
                    }
                })
            })
            ToolbarItem(placement: .principal, content: {
                Text(viewModel.friendsRequest.name)
                    .font(.h4)
                    .foregroundStyle(Color.black)
            })
            ToolbarItem(placement: .topBarTrailing, content: {
                CustomNavigationIcon(navigationIcon: .complete(type: .complete, isEmphasized: true), action: {
                    Task {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        await handleSubmitActoin()
                    }
                })
            })
        })
        .loadingOverlay(isLoading: viewModel.isLoading, loadingType: (friendId == nil) ? .createFriendDiary : .createDiary)
        .overlay(alignment: .bottom, content: {
            DiaryKeyboardControl(isShowCalendar: $viewModel.isShowCalendar, isShowImagePicker: $viewModel.isShowImagePicker)
                .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
                .zIndex(1)
        })
        .alertModifier(
            show: viewModel.checkBackView,
            content: {
                CustomAlert(
                    alertButtonType: (friendId == nil) ? .stopDiaryFirst : .stopDiary,
                    onCancel: {
                        withAnimation(.easeInOut) {
                            self.viewModel.checkBackView = false
                        }
                    },
                    onRight: {
                        Task {
                            self.viewModel.checkBackView = false
                            self.handleNavigationPop()
                        }
                    }
                )
            }
        )
        .fullScreenCover(item: $viewModel.selectedImage, content: { _ in
            DetailImageView(images: $viewModel.diaryImages,
                            selectedImage: $viewModel.selectedImage,
                            onDeleteServerImage: { url in
            }, onDeleteLocalImage: { index in
                viewModel.photoImages.remove(at: index)
            })
        })
        .sheet(isPresented: $viewModel.isShowCalendar, content: {
            SheetCalendarView(viewModel: viewModel)
                .presentationDetents([.medium])
                .presentationCornerRadius(AddDiaryViewConstants.sheetCornerRadius)
        })
        .photosPicker(
            isPresented: $viewModel.isShowImagePicker,
            selection: $viewModel.photoImages,
            maxSelectionCount: AddDiaryViewConstants.maxSelectionCount,
            matching: .images).tint(.orange30)
    }
    
    // MARK: - BottomContents
    /// 하단 일기 내용 작성 컨텐츠
    private var bottomContents: some View {
        VStack(alignment: .leading, spacing: AddDiaryViewConstants.bottomContentsSpacing, content: {
            Group {
                Text(viewModel.dateString)
                    .font(.cap1)
                    .foregroundStyle(Color.gray40)
                
                bottomTextFieldGroup
            }
            .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
        })
        .diaryContainerStyle()
        .sheet()
    }
    
    /// 하단 텍스트 필드 그룹
    private var bottomTextFieldGroup: some View {
        VStack(alignment: .leading, spacing: AddDiaryViewConstants.bottomTextFieldSpacing, content: {
            TextField(AddDiaryViewConstants.titlePlaceholder, text: $viewModel.diaryTitle, prompt: title())
                .font(.h2)
                .foregroundStyle(Color.gray80)
                .submitLabel(.next)
            
            TextField(AddDiaryViewConstants.contentsPlaceholder, text: $viewModel.diaryContents, prompt: subtitle(), axis: .vertical)
                .font(.b1)
                .foregroundStyle(Color.gray80)
                .lineSpacing(AddDiaryViewConstants.lineSpacing)
                .submitLabel(.return)
                .focused($isFocused)
        })
    }
    
    // MARK: - Method
    /// 제목 텍스트 필드 제목 입력
    /// - Returns: placeholder
    private func title() -> Text {
        Text(AddDiaryViewConstants.titlePlaceholder)
            .font(.h2)
            .foregroundStyle(Color.gray40)
    }
    
    private func subtitle() -> Text{
        Text(AddDiaryViewConstants.contentsPlaceholder)
            .font(.b1)
            .foregroundStyle(Color.gray40)
    }
    
    /// 모드에 따른 네비게이션 pop 루트
    private func handleNavigationPop() {
        if friendId == nil {
            container.navigationRouter.popToRooteView()
        } else {
            container.navigationRouter.pop()
        }
    }
    
    /// 상단 네비게이션 완료 액션
    private func handleSubmitActoin() async {
        viewModel.isLoading = true
        
        if let friendId = friendId {
            await viewModel.addDiary(targetFriendId: friendId)
        } else {
            await viewModel.addFriends()
        }
        
        viewModel.isLoading = false
        handleNavigationPop()
    }
    
    private func removeAction(_ index: Int) {
        viewModel.photoImages.remove(at: index)
        viewModel.diaryImages.remove(at: index)
    }
}

#Preview {
    AddDiaryView(friendsRequest: .init(name: "11"), friendId: "11", container: DIContainer())
        .environmentObject(DIContainer())
}
