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
    
    @Bindable var viewModel: CreateDiaryViewModel
    @EnvironmentObject var container: DIContainer
    
    let firstMode: Bool
    
    init(friendsRequest: FriendRequest, container: DIContainer, firstMode: Bool = false) {
        self.viewModel = .init(friendRequest: friendsRequest, container: container)
        self.firstMode = firstMode
    }
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.clear
                .writeDiaryViewBG()
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
            DiaryContainerView(header: {
                topController
            }, imageScroll: {
                if !viewModel.diaryImages.isEmpty {
                    DiaryImageScrollView(images: viewModel.diaryImages, mode: .write,
                                         onDelete: { index in
                        viewModel.photoImages.remove(at: index)
                        viewModel.diaryImages.remove(at: index)
                    }, onSelect: { image in
                        viewModel.selectedImage = image
                    })
                }
            }, content: {
                bottomContents
            })
        }
        
        .overlay(alignment: .bottom, content: {
            DiaryKeyboardControl(isShowCalendar: $viewModel.isShowCalendar, isShowImagePicker: $viewModel.isShowImagePicker)
                .safeAreaPadding(.horizontal, 16)
        })
        
        .overlay(content: {
            if viewModel.checkBackView {
                CustomAlertView(content: {
                    CustomAlert(
                        alertButtonType: firstMode ? .stopDiaryFirst : .diaryDelete,
                        onCancel: {
                            self.viewModel.checkBackView = false
                        },
                        onRight: {
                            Task {
                                self.viewModel.checkBackView = false
                                self.handleNavigationPop()
                            }
                        }
                    )
                })
            }
        })
        
        .fullScreenCover(item: $viewModel.selectedImage, content: { _ in
            DetailImageView(images: $viewModel.diaryImages,
                            selectedImage: $viewModel.selectedImage,
                            onDeleteServerImage: { url in
                print(url)
            }, onDeleteLocalImage: { index in
                viewModel.photoImages.remove(at: index)
            })
        })
        
        .sheet(isPresented: $viewModel.isShowCalendar, content: {
            SheetCalendarView(viewModel: viewModel)
                .presentationCornerRadius(24)
                .presentationDetents([.medium])
        })
        
        .photosPicker(
            isPresented: $viewModel.isShowImagePicker,
            selection: $viewModel.photoImages,
            maxSelectionCount: 5,
            matching: .images).tint(.orange30)
        
            .onChange(of: viewModel.photoImages, { oldValue, newValue in
                Task {
                    await viewModel.convertSelectedPhotosToUIImage()
                }
            })
        
            .task {
                viewModel.dateString = ConvertDataFormat.shared.simpleDateString(from: .now)
            }
        
            .navigationBarBackButtonHidden(true)
    }
    
    /// 상단 네비게이션 컨트롤러
    private var topController: some View {
        CustomNavigation(
            config: .backAndTitleComplete(title: viewModel.friendsRequest.name, isEmphasized: viewModel.diaryIsEmphasized),
            leftAction: { icon in
                switch icon {
                case .backArrow:
                    withAnimation(.easeInOut) {
                        viewModel.checkBackView.toggle()
                    }
                default:
                    break
                }
            },
            rightAction: { icon in
                switch icon {
                case .complete(type: .complete, isEmphasized: viewModel.diaryIsEmphasized):
                    viewModel.addFriendsAndDiary()
                default:
                    break
                }
            })
        .padding(.bottom, 12)
        .safeAreaPadding(.horizontal, 16)
    }
    
    /// 하단 일기 내용 작성 컨텐츠
    private var bottomContents: some View {
        VStack(alignment: .leading, spacing: 28, content: {
            Group {
                Text(viewModel.dateString)
                    .font(.cap1)
                    .foregroundStyle(Color.gray40)
                
                VStack(alignment: .leading, spacing: 10, content: {
                    TextField("제목", text: $viewModel.diaryTitle, prompt: title())
                        .font(.h2)
                        .foregroundStyle(Color.gray80)
                    
                    
                    TextField(contentsPlaceholder, text: $viewModel.diaryContents, prompt: subtitle(), axis: .vertical)
                        .font(.b1)
                        .foregroundStyle(Color.gray80)
                        .lineSpacing(1.6)
                })
            }
            .safeAreaPadding(.horizontal, 16)
        })
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                .fill(Color.whiteBlack)
        }
        .sheet()
    }
    
    
    /// 제목 텍스트 필드 제목 입력
    /// - Returns: placeholder
    private func title() -> Text {
        Text(titlePlaceholder)
            .font(.h2)
            .foregroundStyle(Color.gray40)
    }
    
    private func subtitle() -> Text{
        Text(contentsPlaceholder)
            .font(.b1)
            .foregroundStyle(Color.gray40)
    }
    
    /// 모드에 따른 네비게이션 pop 루트
    private func handleNavigationPop() {
        if firstMode {
            container.navigationRouter.popToRooteView()
        } else {
            container.navigationRouter.pop()
        }
    }
}

extension AddDiaryView {
    private var titlePlaceholder: String { "제목" }
    private var contentsPlaceholder: String { "친구와의 기억을 적어주세요" }
}

#Preview {
    AddDiaryView(friendsRequest: .init(name: "하하", birthDay: "199"), container: DIContainer())
        .environmentObject(DIContainer())
}
