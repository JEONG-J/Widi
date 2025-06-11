//
//  FloatingCharacterView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/12/25.
//

import SwiftUI
import Kingfisher

struct FloatingCharacterView: View {
    let friend: FriendResponse
    let screenSize: CGSize
    
    @Binding var allCharacters: [CharacterState]
    private let characterSize: CGSize = CGSize(width: 120, height: 110)
    
    @State private var position: CGPoint = .zero
    @State private var direction: CGVector = .init(dx: CGFloat.random(in: -1.0...1.0), dy: CGFloat.random(in: -1.0...1.0))
    @State private var showHeart: Bool = false
    @State private var heartOffset: CGFloat = 0
    @State private var heartOpacity: Double = 1.0
    @State private var heartStates: [HeartState] = []
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.03)) { context in
            characterImage()
                .position(position)
                .task {
                    position = initialPosition()
                    direction = randomDirection()
                    updateSharedState()
                }
                .onChange(of: context.date) { _, _ in
                    guard friend.experienceDTO.experiencePoint >= 4 else { return }
                    updatePosition()
                    checkCollision()
                    updateSharedState()
                }
                .onTapGesture(count: 2) {
                    let newHeart = HeartState()
                    heartStates.append(newHeart)

                    withAnimation(.easeOut(duration: 1.0)) {
                        if let index = heartStates.firstIndex(where: { $0.id == newHeart.id }) {
                            heartStates[index].offset = -50
                            heartStates[index].opacity = 0.0
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        heartStates.removeAll(where: { $0.id == newHeart.id })
                    }
                }
        }
    }
    
    @ViewBuilder
    private func characterImage() -> some View {
        VStack(spacing: 4) {
            KFImage(URL(string: friend.experienceDTO.characterInfo.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 110)
            
            Text(friend.name)
                .font(.caption)
                .foregroundColor(.black)
        }
        .overlay(alignment: .top, content: {
            ForEach(heartStates) { heart in
                let elapsed = Date().timeIntervalSince(heart.creationDate)
                let yOffset = heart.offset
                let xWiggle = CGFloat(sin(elapsed * 10) * 6)

                Image(.heart)
                    .resizable()
                    .frame(width: 32, height: 28)
                    .font(.title)
                    .foregroundColor(.red)
                    .offset(x: xWiggle, y: yOffset)
                    .opacity(heart.opacity)
            }
        })
    }
    
    private func initialPosition() -> CGPoint {
        CGPoint(
            x: CGFloat(friend.experienceDTO.characterInfo.x),
            y: CGFloat(friend.experienceDTO.characterInfo.y)
        )
    }
    
    private func randomDirection() -> CGVector {
        CGVector(
            dx: Double.random(in: -1.5...1.5),
            dy: Double.random(in: -1.5...1.5)
        )
    }
    
    private func updateSharedState() {
        if let index = allCharacters.firstIndex(where: { $0.id == friend.documentId }) {
            allCharacters[index].position = position
            allCharacters[index].direction = direction
        }
    }
    
    private func updatePosition() {
        guard let index = allCharacters.firstIndex(where: { $0.id == friend.documentId }) else { return }
        
        var current = allCharacters[index]
        
        var newX = current.position.x + current.direction.dx
        var newY = current.position.y + current.direction.dy
        
        let minX = characterSize.width / 2
        let maxX = screenSize.width - characterSize.width / 2
        let minY = characterSize.height / 2
        let maxY = screenSize.height - characterSize.height / 2
        
        if newX < minX || newX > maxX {
            current.direction.dx *= -1
            newX = min(max(newX, minX), maxX)
        }
        
        if newY < minY || newY > maxY {
            current.direction.dy *= -1
            newY = min(max(newY, minY), maxY)
        }
        
        current.position = CGPoint(x: newX, y: newY)
        
        for other in allCharacters where other.id != current.id {
            let distance = current.position.distance(to: other.position)
            if distance < 100 {
                current.direction = CGVector(
                    dx: CGFloat.random(in: -1.5...1.5),
                    dy: CGFloat.random(in: -1.5...1.5)
                )
                break
            }
        }
        
        allCharacters[index] = current
        position = current.position
        direction = current.direction
    }
    private func checkCollision() {
        for other in allCharacters where other.id != friend.documentId {
            let myFrame = CGRect(x: position.x - characterSize.width/2,
                                 y: position.y - characterSize.height/2,
                                 width: characterSize.width,
                                 height: characterSize.height)
            
            let otherFrame = CGRect(x: other.position.x - characterSize.width/2,
                                    y: other.position.y - characterSize.height/2,
                                    width: characterSize.width,
                                    height: characterSize.height)
            
            if myFrame.intersects(otherFrame) {
                direction.dx *= -1
                direction.dy *= -1
                break
            }
        }
    }
}

struct HeartState: Identifiable {
    let id = UUID()
    var offset: CGFloat = 0
    var opacity: Double = 1.0
    var creationDate: Date = Date()
}
