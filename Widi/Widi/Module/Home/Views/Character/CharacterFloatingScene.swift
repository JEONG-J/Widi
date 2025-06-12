//
//  Scenen.swift
//  Widi
//
//  Created by Apple Coding machine on 6/12/25.
//

import SwiftUI

struct CharacterFloatingScene: View {
    @State private var allCharacters: [CharacterState] = []
    @State private var isLoaded = false
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
            let screenWidth = getScreenSize().width
            let screenHeight = getScreenSize().height

            var usedPositions: [CGPoint] = []

            let initializedCharacters = friends.map { friend -> CharacterState in
                var position: CGPoint
                repeat {
                    position = CGPoint(
                        x: CGFloat.random(in: 80...(screenWidth - 80)),
                        y: CGFloat.random(in: 150...(screenHeight - 150))
                    )
                } while usedPositions.contains(where: { $0.distance(to: position) < 100 })

                usedPositions.append(position)

                return CharacterState(
                    id: friend.documentId,
                    position: position,
                    direction: CGVector(
                        dx: Double.random(in: -1.5...1.5),
                        dy: Double.random(in: -1.5...1.5)
                    )
                )
            }

            allCharacters = initializedCharacters
            isLoaded = true
        }
    }
}

#Preview {
    CharacterFloatingScene(friends: [
        .init(
            documentId: "11",
            friendId: "11",
            name: "루카",
            experienceDTO: .init(
                experiencePoint: 4,
                characterInfo: .init(
                    imageURL: "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelFourF.png?alt=media&token=ee6de20d-423b-4765-b82f-ec9c50677080",
                    x: 120,
                    y: 100
                )
            )
        ),
        .init(
            documentId: "121",
            friendId: "22",
            name: "지나",
            experienceDTO: .init(
                experiencePoint: 4,
                characterInfo: .init(
                    imageURL: "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelFourC.png?alt=media&token=75e96b0f-68db-47d7-82b2-228920b3957f",
                    x: 300,
                    y: 10
                )
            )
        )
    ])
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
