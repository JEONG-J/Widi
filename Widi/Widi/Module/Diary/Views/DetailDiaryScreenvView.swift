//
//  DetailDiaryScreenvView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/10/25.
//

import SwiftUI

/// 일기 읽기 뷰 및 수정 뷰
struct DetailDiaryScreenvView: View {
    
    @EnvironmentObject var container: DIContainer
    @Bindable var viewModel: DetailDiaryViewModel
    
    let friendName: String
    
    init(friendName: String, diaryMode: DiaryMode, container: DIContainer, diaryResponse: DiaryResponse) {
        self.friendName = friendName
        self.viewModel = .init(diaryMode: diaryMode, container: container, diary: diaryResponse)
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .writeDiaryViewBG()
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
            if let diary = viewModel.diary {
                
                DiaryContainerView(header: { topController() }, imageScroll: {
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
        
        .overlay(alignment: .bottom, content: {
            if viewModel.diaryMode == .edit {
                DiaryKeyboardControl(isShowCalendar: $viewModel.isShowCalendar, isShowImagePicker: $viewModel.isShowImagePicker)
                    .safeAreaPadding(.horizontal, 16)
                    .zIndex(1)
            }
        })
        
        .overlay(content: {
            if viewModel.isShowDeleteDiaryAlert {
                CustomAlertView(content: {
                    CustomAlert(
                        alertButtonType: .diaryDelete,
                        onCancel: {
                            viewModel.isShowDeleteDiaryAlert = false
                        },
                        onRight: {
                            Task {
                                await viewModel.deleteDiary()
                                viewModel.isShowDeleteDiaryAlert = false
                                container.navigationRouter.pop()
                            }
                        }
                    )
                })
            } else if viewModel.isShowStopEditAlert {
                CustomAlertView(content: {
                    CustomAlert(alertButtonType: .stopEdit,
                                onCancel: {
                        viewModel.isShowStopEditAlert = false
                    },
                                onRight: {
                        viewModel.isShowStopEditAlert = false
                        viewModel.diaryMode = .read
                    })
                })
            }
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
                viewModel.photoImages.remove(at: index)
                viewModel.selectedImage = nil
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
        
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - topNavigation
    
    @ViewBuilder
    private func topController() -> some View {
        Group {
            switch viewModel.diaryMode {
            case .read:
                readNavigation
            case .edit:
                editNavigaation
            default:
                EmptyView()
            }
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.bottom, 12)
        .safeAreaPadding(.top, 4)
    }
    
    /// 읽기 네비게이션
    private var readNavigation: some View {
        CustomNavigation(config: .backTitleAndEditTrash(title: friendName), leftAction: { icon in
            switch icon {
            case .backArrow:
                container.navigationRouter.pop()
            default:
                break
            }
            
        }, rightAction: { icon in
            switch icon {
            case .edit:
                viewModel.diaryMode = .edit
            case .trash:
                withAnimation(.easeInOut) {
                    viewModel.isShowDeleteDiaryAlert.toggle()
                }
            default:
                break
            }
        })
    }
    
    private var editNavigaation: some View {
        CustomNavigation(config: .backAndComplete(isEmphasized: true), leftAction: { icon in
            switch icon {
            case .backArrow:
                withAnimation(.easeInOut) {
                    viewModel.isShowStopEditAlert.toggle()
                }
            default:
                break
            }
            
        }, rightAction: { icon in
            switch icon {
            case .complete(type: .complete, isEmphasized: true):
                    Task {
                        await viewModel.saveEditContent()
                        viewModel.diaryMode = .read
                    }
            default:
                break
            }
        })
    }
    
    // MARK: - BottomContents
    @ViewBuilder
    private func bottomContents(data: DiaryResponse) -> some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 28) {
                    Group {
                        Text(data.diaryDate)
                            .font(.cap1)
                            .foregroundStyle(Color.gray40)

                        VStack(alignment: .leading, spacing: 10) {
                            if let _ = data.title {
                                TextField(titlePlaceholder, text: $viewModel.diaryTitle, prompt: title())
                                    .font(.h2)
                                    .foregroundStyle(Color.gray80)
                            }

                            TextEditor(text: $viewModel.diaryContents)
                                .font(.b1)
                                .foregroundStyle(Color.gray80)
                                .lineSpacing(1.6)
                                .frame(minHeight: 200, alignment: .topLeading)
                                .disabled(viewModel.diaryMode == .read)
                                .scrollDisabled(true)
                        }
                        .disabled(viewModel.diaryMode == .read)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 100)
                .frame(minHeight: geo.size.height)
            }
            .frame(height: geo.size.height)
        }
        .diaryContainerStyle()
        .ignoresSafeArea(edges: .bottom)
        .sheet()
    }
    
    /// 제목 placeholder
    /// - Returns: Text 값 반환
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
}

extension DetailDiaryScreenvView {
    var titlePlaceholder: String { "제목" }
    var contentsPlaceholder: String { "친구와의 기억을 적어주세요" }
}
