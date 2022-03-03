//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by Vishal on 03/03/22.
//

import SwiftUI

enum Move: String {
    case rock
    case paper
    case scissors

    var supersededBy: Move {
        switch self {
        case .rock: return .paper
        case .paper: return .scissors
        case .scissors: return .rock
        }
    }

    var image: some View {
        let image: Image

        switch self {
        case .rock: image = Image("rock")
        case .paper: image = Image("paper")
        case .scissors: image = Image("scissors")
        }

        return image
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    static var all: [Move] {
        return [.rock, .paper, .scissors]
    }
}

// text style
struct GameText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(
                Color(
                    hue: 0.095,
                    saturation: 0.669,
                    brightness: 0.55,
                    opacity: 1.0
                )
            )
    }
}

extension View {
    func applyGameTextStyle() -> some View {
        return self.modifier(GameText())
    }
}

struct BackgroundImage: View {
    var body: some View {
        Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}

struct PossibleMoves: View {
    let tapHandler: (Move) -> Void

    var body: some View {
        HStack {
            ForEach(Move.all, id: \.self) { move in
                Button(action: {
                    tapHandler(move)
                }) {
                    move.image
                        .frame(width: 80, height: 200, alignment: .center)
                }
            }
        }
    }
}

struct Game: View {
    let randomMove: Move
    let shouldWin: Bool
    let tapHandler: (Move) -> Void

    var body: some View {
        VStack {
            Text("\(shouldWin ? "Win" : "Loose") against")
                .applyGameTextStyle()
                .font(.title3.bold())
                .opacity(0.7)
            randomMove.image
                .frame(width: 180, height: 200, alignment: .center)
            PossibleMoves(tapHandler: tapHandler)
        }
    }
}

struct ContentView: View {
    @State var randomMove: Move = Move.all.randomElement()!
    @State var shouldWin: Bool = Bool.random()
    @State var score: Int = 0
    @State var moveCount: Int = 0
    @State var showScores: Bool = false

    private let totalMoves: Int = 5

    var body: some View {
        ZStack {
            BackgroundImage()
            if (!showScores) {
                VStack {
                    Game(
                        randomMove: randomMove,
                        shouldWin: shouldWin,
                        tapHandler: { move in
                            chooseMove(move)
                        }
                    )
                }
            } else {
                VStack {
                    Spacer()
                    Spacer()
                    Text("Your score")
                        .applyGameTextStyle()
                        .font(.title2)
                    Text("\(score)")
                        .applyGameTextStyle()
                        .font(.title.bold())
                    Spacer()
                    Button("Restart", action: { reset() })
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(
                            hue: 0.095,
                            saturation: 0.669,
                            brightness: 0.55,
                            opacity: 1.0
                        ))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Spacer()
                    Spacer()
                }
            }
        }
    }

    func chooseMove(_ move: Move) {
        let winningMove = randomMove.supersededBy
        if shouldWin == (winningMove == move) {
            score += 1
        }

        moveCount += 1

        if moveCount >= totalMoves {
            showScores = true
        } else {
            nextMove()
        }
    }

    func nextMove() {
        randomMove = Move.all.randomElement()!
        shouldWin.toggle()
    }

    func reset() {
        score = 0
        moveCount = 0
        showScores = false
        nextMove()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
