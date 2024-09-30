//
//  ContentView.swift
//  DungeonDice
//
//  Created by Anora Zhu on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    
    enum Dice: Int, CaseIterable {
        case four = 4
        case six = 6
        case eight = 8
        case ten = 10
        case twelve = 12
        case twenty = 20
        case hundred = 100
        
        func roll() -> Int {
            return Int.random(in: 1...self.rawValue)
        }
    }
    
    @State private var resultMessage = ""
    @State private var buttonsLeftOver = 0 //number of buttons less than a full row
    
    let horizontalPadding: CGFloat = 16
    let spacing: CGFloat = 0 // between buttons
    let buttonWidth: CGFloat =  102
    
    var body: some View {
        GeometryReader { geo in
            
            VStack {
                Text("Dungeon Dice")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.red)
                
                Spacer()
                
                Text(resultMessage)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .frame(height: 150)
                
                Spacer()
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: buttonWidth), spacing: spacing)]){
                    ForEach(Dice.allCases.dropLast(buttonsLeftOver), id: \.self) { dice in
                        Button("\(dice.rawValue)-sided") {
                            resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                        }
                        .frame(width: buttonWidth)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                
                HStack {
                    ForEach(Dice.allCases.suffix(buttonsLeftOver), id: \.self) {
                        dice in
                        Button("\(dice.rawValue)-sided") {
                            resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                        }
                        .frame(width: buttonWidth)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                }
                                
                .onChange(of: geo.size.width, {
                    arraangeGridItems(geo:geo)
                })
                
                .onAppear {
                    arraangeGridItems(geo: geo)
                }
            }
        }
    }
    func arraangeGridItems(geo: GeometryProxy) {
        var screenWidth = geo.size.width - horizontalPadding*2 // padding on both sides
        if Dice.allCases.count > 1 {
            screenWidth += spacing
        }
        
        //calculate numOfButtonsPerRow as an Int
        let numberOfButtonsPerRow = Int(screenWidth) / Int(buttonWidth + spacing)
        buttonsLeftOver = Dice.allCases.count % numberOfButtonsPerRow
        print("numberOfButtonsperRow \(numberOfButtonsPerRow)")
        print("buttonsLeftOver = \(buttonsLeftOver)")
    }
}

#Preview {
    ContentView()
}
