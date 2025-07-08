//
//  DetailDiaryScreenvView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/10/25.
//

import SwiftUI

/// 일기 읽기 뷰 및 수정 뷰
struct DetailDiaryScreenvView: View {
    
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @Bindable var viewModel: DetailDiaryViewModel
    let friendName: String
    
    // MARK: - Enum
    fileprivate enum DetailDiaryConstants {
        
        static let topNavigationVerticalPadding: CGFloat = 11
        // 텍스트
        static let titlePlaceholder = "제목"
        static let contentsPlaceholder = "친구와의 기억을 적어주세요"
        
        // 레이아웃 수치
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 100
        static let contentSpacing: CGFloat = 28
        static let fieldSpacing: CGFloat = 10
        static let textEditorMinHeight: CGFloat = 200
        
        // 시트
        static let calendarCornerRadius: CGFloat = 24
    }
    
    init(friendName: String, container: DIContainer, diaryResponse: DiaryResponse) {
        self.friendName = friendName
        self.viewModel = .init(container: container, diary: diaryResponse)
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .writeDiaryViewBG()
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
            if let diary = viewModel.diary {
                
                DiaryContainerView(imageScroll: {
                    if !viewModel.diaryImages.isEmpty {
                        DiaryImageScrollView(images: viewModel.diaryImages, mode: viewModel.diaryMode,
                                             onDelete: { index in
                            viewModel.deleteImage(index: index)
                        }, onSelect: { image in
                            viewModel.selectedImage = image
                        })
                    }
                }, content: {
                    bottomContents(data: diary)
                })
            } else {
                ProgressView()
                    .controlSize(.regular)
                    .tint(.orange30)
            }
        }
        .loadingOverlay(isLoading: viewModel.isEditLoading, loadingType: .editDiary)
        .loadingOverlay(isLoading: viewModel.isDeleteLoading, loadingType: .diaryDelete)
        
        .overlay(alignment: .bottom, content: {
            if viewModel.diaryMode == .edit {
                DiaryKeyboardControl(isShowCalendar: $viewModel.isShowCalendar, isShowImagePicker: $viewModel.isShowImagePicker)
                    .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
                    .zIndex(1)
            }
        })
        .alertModifier(show: viewModel.isShowDeleteDiaryAlert, content: {
            CustomAlert(
                alertButtonType: .diaryDelete,
                onCancel: {
                    viewModel.isShowDeleteDiaryAlert = false
                },
                onRight: {
                    Task {
                        viewModel.isShowDeleteDiaryAlert = false
                        await viewModel.deleteDiary()
                        container.navigationRouter.pop()
                    }
                }
            )
        })
        .alertModifier(show: viewModel.isShowStopEditAlert, content: {
            CustomAlert(alertButtonType: .stopEdit,
                        onCancel: {
                viewModel.isShowStopEditAlert = false
            },
                        onRight: {
                viewModel.isShowStopEditAlert = false
                viewModel.diaryMode = .read
            })
        })
        .fullScreenCover(item: $viewModel.selectedImage, content: { _ in
            DetailImageView(images: $viewModel.diaryImages,
                            selectedImage: $viewModel.selectedImage,
                            onDeleteServerImage: { url in
                Task {
                    await viewModel.deleteServerImage(url: url)
                    viewModel.selectedImage = nil
                }
            }, onDeleteLocalImage: { index in
                viewModel.selectedImage = nil
                viewModel.photoImages.remove(at: index)
            })
        })
        .sheet(isPresented: $viewModel.isShowCalendar, content: {
            SheetCalendarView(viewModel: viewModel, isSelected: ConvertDataFormat.shared.date(from: viewModel.dateString) ?? Date())
                .presentationCornerRadius(DetailDiaryConstants.calendarCornerRadius)
                .presentationDetents([.fraction(0.55)])
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
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            switch viewModel.diaryMode {
            case .read:
                // 왼쪽: 뒤로가기
                ToolbarItem(placement: .topBarLeading) {
                    CustomNavigationIcon(navigationIcon: .backArrow, action: {
                        container.navigationRouter.pop()
                    })
                    .padding(.vertical, DetailDiaryConstants.topNavigationVerticalPadding)
                }

                
                // 가운데: 친구 이름
                ToolbarItem(placement: .principal) {
                    Text(friendName)
                        .font(.h4)
                        .foregroundStyle(Color.black)
                }

                // 오른쪽: 수정 & 삭제
                ToolbarItemGroup(placement: .topBarTrailing) {
                    CustomNavigationIcon(navigationIcon: .edit, action: {
                        viewModel.diaryMode = .edit
                    })
                    .padding(.vertical, DetailDiaryConstants.topNavigationVerticalPadding)

                    CustomNavigationIcon(navigationIcon: .trash, action: {
                        withAnimation(.easeInOut) {
                            viewModel.isShowDeleteDiaryAlert.toggle()
                        }
                    })
                    .padding(.vertical, DetailDiaryConstants.topNavigationVerticalPadding)
                }

            case .edit:
                ToolbarItem(placement: .topBarLeading, content: {
                    CustomNavigationIcon(navigationIcon: .backArrow, action: {
                        withAnimation(.easeInOut) {
                            viewModel.isShowStopEditAlert.toggle()
                        }
                    })
                    .padding(.vertical, DetailDiaryConstants.topNavigationVerticalPadding)
                })
                    
                ToolbarItem(placement: .topBarTrailing, content: {
                    CustomNavigationIcon(navigationIcon: .complete(type: .complete, isEmphasized: true), action: {
                        Task {
                            await viewModel.saveEditContent()
                            viewModel.diaryMode = .read
                        }
                    })
                    .padding(.vertical, DetailDiaryConstants.topNavigationVerticalPadding)
                })
            case .write:
                EmptyToolbar()
            }
        }
    }
    
    // MARK: - BottomContents
    @ViewBuilder
    private func bottomContents(data: DiaryResponse) -> some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: DetailDiaryConstants.contentSpacing) {
                    Group {
                        Text(viewModel.dateString)
                            .font(.cap1)
                            .foregroundStyle(Color.gray40)

                        VStack(alignment: .leading, spacing: DetailDiaryConstants.fieldSpacing) {
                            if let _ = data.title {
                                TextField(DetailDiaryConstants.titlePlaceholder, text: $viewModel.diaryTitle, prompt: title())
                                    .font(.h2)
                                    .foregroundStyle(Color.gray80)
                            }

                            TextEditor(text: $viewModel.diaryContents)
                                .font(.b1)
                                .foregroundStyle(Color.gray80)
                                .lineSpacing(1.6)
                                .frame(minHeight: DetailDiaryConstants.textEditorMinHeight, alignment: .topLeading)
                                .disabled(viewModel.diaryMode == .read)
                                .scrollDisabled(true)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                        }
                        .disabled(viewModel.diaryMode == .read)
                    }
                    .padding(.horizontal, DetailDiaryConstants.horizontalPadding)
                }
                .padding(.bottom, DetailDiaryConstants.bottomPadding)
                .frame(minHeight: geo.size.height)
            }
            .frame(height: geo.size.height)
            .diaryContainerStyle()
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet()
    }
    
    /// 제목 placeholder
    /// - Returns: Text 값 반환
    private func title() -> Text {
        Text(DetailDiaryConstants.titlePlaceholder)
            .font(.h2)
            .foregroundStyle(Color.gray40)
    }
    
    private func subtitle() -> Text{
        Text(DetailDiaryConstants.contentsPlaceholder)
            .font(.b1)
            .foregroundStyle(Color.gray40)
    }
}


struct EmptyToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            EmptyView()
        }
    }
}
