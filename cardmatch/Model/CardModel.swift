//
//  File.swift
//  cardmatch
//
//  Created by Rahul khurana on 03/01/19.
//  Copyright © 2019 Rahul khurana. All rights reserved.
//

import Foundation

class CardModel{
    
    var genearatedCardArray = [Card]()

    func getCard() -> [Card]
{
    
    for _ in 1...8
    {
        let generatedNumber = arc4random_uniform(13)+1
        
        let card = Card()
        card.imageName = "card\(generatedNumber)"
        
        genearatedCardArray.append(card)
        
        let card2 = Card()
        card2.imageName = "card\(generatedNumber)"
        
        genearatedCardArray.append(card2)
        print(generatedNumber)
    }
    
    return genearatedCardArray;
    }
}
