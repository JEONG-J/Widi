//
//  CustomNavigation].swift
//  Widi
//
//  Created by Apple Coding machine on 6/3/25.
//

import SwiftUI

struct CustomNavigation: View {
    
    // MARK: - Property
    
    let config: NavigationBarConfig
    let leftAction: (NavigationIcon) -> Void
    let rightAction: (NavigationIcon) -> Void
    
    // MARK: - Init
    
    /// 네비게이션 커스텀 타입으로 분리
    /// - Parameters:
    ///   - config: 네비게이션 타입 선택
    ///   - leftAction: 왼쪽 네비게이션 버튼 액션 지정
    ///   - rightAction: 오른쪽 네비게이션 버튼 액션 지정
    init(
        config: NavigationBarConfig,
         leftAction: @escaping (NavigationIcon) -> Void,
         rightAction: @escaping (NavigationIcon) -> Void
    ) {
        self.config = config
        self.leftAction = leftAction
        self.rightAction = rightAction
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            leftIcon
            
            Spacer()
            
            centerTitle
            
            Spacer()
            
            rightIcon
        }
    }
    
    /// 왼쪽 아이콘
    private var leftIcon: some View {
        HStack(spacing: 12, content: {
            ForEach(config.left, id: \.self) { icon in
                CustomNavigationIcon(navigationIcon: icon, action: {
                    leftAction(icon)
                })
            }
        })
    }
    
    /// 오른쪽 아이콘
    private var rightIcon: some View {
        HStack(spacing: 12, content: {
            ForEach(config.right, id: \.self) { icon in
                CustomNavigationIcon(navigationIcon: icon, action: {
                    rightAction(icon)
                })
            }
        })
    }
    
    /// 중간 타이틀
    @ViewBuilder
    private var centerTitle: some View {
        if let title = config.center {
            Text(title)
                .font(.h4)
                .foregroundStyle(Color.black)
        }
    }
}

#Preview {

    CustomNavigation(
        config: .backTitleAndEditTrash(title: "Hello"),
        leftAction: { icon in
            switch icon {
            case .backArrow:
                print("backArrow가 눌렸습니다.")
            default:
                break
            }
        },
        rightAction: { icon in
            switch icon {
            case .edit:
                print("pencil가 눌렸습니다.")
            case .trash:
                print("trash가 눌렸습니다.")
            default:
                break
            }
        }
    )
    
//    CustomNavigation(
//        config: .backAndClose,
//        leftAction: { icon in
//            switch icon {
//            case .backArrow:
//                print("Back tapped")
//            default:
//                break
//            }
//        },
//        rightAction: { icon in
//            switch icon {
//            case .closeX:
//                print("xx")
//            default:
//                break
//            }
//        }
//    )
}
