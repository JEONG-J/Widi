//
//  Scenen.swift
//  Widi
//
//  Created by Apple Coding machine on 6/12/25.
//

import SwiftUI

struct CharacterFloatingScene: View {
    @Binding var allCharacters: [CharacterState]
    @Binding var isLoaded: Bool
    let friends: [FriendResponse]
    
    var body: some View {
        Group {
            if isLoaded {
                ForEach(friends, id: \.documentId) { friend in
                    FloatingCharacterView(
                        friend: friend,
                        screenSize: getScreenSize(),
                        allCharacters: $allCharacters
                    )
                }
            } else {
                ProgressView("캐릭터를 불러오는 중...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(1.5)
            }
        }
        .task {
            let screenSize = getScreenSize()
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height

            var usedPositions: [CGPoint] = []

            let initializedCharacters: [CharacterState] = friends.compactMap { friend in
                guard let documentId = friend.documentId else {
                    print("documentId가 없습니다. 캐릭터를 초기화할 수 없습니다.")
                    return nil
                }

                var position: CGPoint
                repeat {
                    position = CGPoint(
                        x: CGFloat.random(in: 80...(screenWidth - 80)),
                        y: CGFloat.random(in: 150...(screenHeight - 150))
                    )
                } while usedPositions.contains(where: { $0.distance(to: position) < 100 })

                usedPositions.append(position)

                return CharacterState(
                    id: documentId,
                    position: position,
                    direction: CGVector(
                        dx: Double.random(in: -1.5...1.5),
                        dy: Double.random(in: -1.5...1.5)
                    )
                )
            }

            await MainActor.run {
                self.allCharacters = initializedCharacters
                self.isLoaded = true
            }
        }
    }
}

struct CharacterState: Identifiable {
    let id: String
    var position: CGPoint
    var direction: CGVector
}


extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
