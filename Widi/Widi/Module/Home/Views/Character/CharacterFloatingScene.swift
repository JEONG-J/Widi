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
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .task {
            await setupCharacters()
        }
    }

    @MainActor
    private func setupCharacters() async {
        isLoaded = false

        let screenSize = getScreenSize()
        var usedPositions: [CGPoint] = []

        let characters: [CharacterState] = friends.compactMap { friend in
            guard let id = friend.documentId else {
                print("documentId 없음 - \(friend)")
                return nil
            }

            let position = generateNonOverlappingPosition(
                screenSize: screenSize,
                usedPositions: &usedPositions,
                minDistance: 100
            )

            return CharacterState(
                id: id,
                position: position,
                direction: .init(
                    dx: Double.random(in: -1.5...1.5),
                    dy: Double.random(in: -1.5...1.5)
                )
            )
        }

        allCharacters = characters
        isLoaded = true
    }

    private func generateNonOverlappingPosition(
        screenSize: CGSize,
        usedPositions: inout [CGPoint],
        minDistance: CGFloat
    ) -> CGPoint {
        var newPosition: CGPoint
        repeat {
            newPosition = CGPoint(
                x: CGFloat.random(in: 80...(screenSize.width - 80)),
                y: CGFloat.random(in: 150...(screenSize.height - 150))
            )
        } while usedPositions.contains(where: { $0.distance(to: newPosition) < minDistance })

        usedPositions.append(newPosition)
        return newPosition
    }
}

struct CharacterState: Identifiable {
    let id: String
    var position: CGPoint
    var direction: CGVector
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        hypot(x - point.x, y - point.y)
    }
}
